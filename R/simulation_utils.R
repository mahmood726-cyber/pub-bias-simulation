#' Load Simulation Summary Data
#'
#' Reads the comprehensive simulation summary CSV and returns a data frame
#' with properly typed columns.
#'
#' @param path Path to the comprehensive_simulation_summary.csv file.
#'   Defaults to the file in the project root.
#' @return A data frame with 135 rows (one per scenario) and 38 columns.
#' @export
load_simulation_summary <- function(path = NULL) {
  if (is.null(path)) {
    # Try common locations
    candidates <- c(
      "comprehensive_simulation_summary.csv",
      file.path("..", "comprehensive_simulation_summary.csv"),
      file.path(system.file(package = "pubbias.sim"),
                "comprehensive_simulation_summary.csv")
    )
    path <- NULL
    for (p in candidates) {
      if (file.exists(p)) {
        path <- p
        break
      }
    }
    if (is.null(path)) {
      stop("Cannot find comprehensive_simulation_summary.csv. ",
           "Provide the path explicitly.")
    }
  }

  df <- read.csv(path, stringsAsFactors = FALSE)

  # Ensure factor columns
  df$bias_type <- factor(df$bias_type)
  df$k_scenario <- factor(df$k_scenario, levels = c(10, 20, 50))

  df
}


#' Summarize Method Performance
#'
#' Produces a concise summary table of method performance metrics
#' across simulation conditions.
#'
#' @param df Data frame from \code{load_simulation_summary()}.
#' @param metric One of "bias", "rmse", "mae", "coverage".
#' @return A data frame with mean and SD of the metric for each method.
#' @export
summarize_performance <- function(df, metric = c("bias", "rmse", "mae", "coverage")) {
  metric <- match.arg(metric)

  methods <- c("naive", "tf", "pp", "copas")
  labels  <- c("Naive RE", "Trim & Fill", "PET-PEESE", "Copas")
  cols    <- paste0(methods, "_", metric)

  results <- data.frame(
    Method = labels,
    Mean   = sapply(cols, function(col) mean(df[[col]], na.rm = TRUE)),
    SD     = sapply(cols, function(col) sd(df[[col]], na.rm = TRUE)),
    Min    = sapply(cols, function(col) min(df[[col]], na.rm = TRUE)),
    Max    = sapply(cols, function(col) max(df[[col]], na.rm = TRUE)),
    stringsAsFactors = FALSE
  )
  rownames(results) <- NULL
  results
}
