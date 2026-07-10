test_that("load_simulation_summary types columns and applies factor levels", {
  tmp <- tempfile(fileext = ".csv")
  on.exit(unlink(tmp), add = TRUE)
  df_in <- data.frame(
    bias_type = c("none", "continuous", "step"),
    k_scenario = c(10, 20, 50),
    true_effect = c(0.3, 0.5, 0.8),
    naive_bias = c(0.01, 0.02, 0.03),
    naive_coverage = c(0.94, 0.95, 0.96),
    stringsAsFactors = FALSE
  )
  write.csv(df_in, tmp, row.names = FALSE)

  df <- load_simulation_summary(path = tmp)
  expect_s3_class(df$bias_type, "factor")
  expect_s3_class(df$k_scenario, "factor")
  expect_identical(levels(df$k_scenario), c("10", "20", "50"))
})

test_that("k_scenario values outside c(10,20,50) become NA (documented behavior)", {
  tmp <- tempfile(fileext = ".csv")
  on.exit(unlink(tmp), add = TRUE)
  df_in <- data.frame(
    bias_type = c("none", "none"),
    k_scenario = c(10, 30),  # 30 is not a hard-coded level
    naive_bias = c(0.01, 0.02),
    stringsAsFactors = FALSE
  )
  write.csv(df_in, tmp, row.names = FALSE)

  df <- load_simulation_summary(path = tmp)
  expect_true(is.na(df$k_scenario[2]))
})

test_that("summarize_performance returns one row per method for each metric", {
  df <- data.frame(
    naive_bias = c(0.1, 0.2), tf_bias = c(0.1, 0.2),
    pp_bias = c(0.1, 0.2), copas_bias = c(0.1, 0.2),
    naive_coverage = c(0.94, 0.95), tf_coverage = c(0.9, 0.92),
    pp_coverage = c(0.5, 0.6), copas_coverage = c(0.93, 0.94)
  )
  for (m in c("bias", "coverage")) {
    out <- summarize_performance(df, metric = m)
    expect_equal(nrow(out), 4L)
    expect_setequal(out$Method,
                    c("Naive RE", "Trim & Fill", "PET-PEESE", "Copas"))
    expect_true(all(c("Mean", "SD", "Min", "Max") %in% names(out)))
  }
})

test_that("summarize_performance with an all-NA metric column yields Inf min/max", {
  # Documents (not endorses) the current na.rm=TRUE min/max behavior:
  # an entirely-NA column returns Inf/-Inf rather than NA. The Python
  # contract test guards the shipped CSV against ever hitting this path.
  df <- data.frame(
    naive_rmse = c(NA_real_, NA_real_), tf_rmse = c(0.1, 0.2),
    pp_rmse = c(0.1, 0.2), copas_rmse = c(0.1, 0.2)
  )
  out <- suppressWarnings(summarize_performance(df, metric = "rmse"))
  expect_true(is.infinite(out$Min[out$Method == "Naive RE"]))
})
