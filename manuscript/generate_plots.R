#!/usr/bin/env Rscript
# generate_plots.R — Generate manuscript figures from simulation summary data
#
# Usage: Run from the manuscript/ directory, or from the project root:
#   Rscript manuscript/generate_plots.R
#
# Output: bias_plot.png, rmse_plot.png, coverage_plot.png in manuscript/

library(ggplot2)
library(dplyr)
library(tidyr)

# --- Resolve paths robustly ---
script_dir <- if (interactive()) {
  "manuscript"
} else {
  dirname(normalizePath(commandArgs(trailingOnly = FALSE)[
    grep("--file=", commandArgs(trailingOnly = FALSE))
  ] |> sub("--file=", "", x = _), mustWork = FALSE))
}

# Try to find the CSV relative to script location or working directory
csv_candidates <- c(
  file.path(script_dir, "..", "comprehensive_simulation_summary.csv"),
  "comprehensive_simulation_summary.csv",
  "../comprehensive_simulation_summary.csv"
)
csv_path <- NULL
for (p in csv_candidates) {
  if (file.exists(p)) {
    csv_path <- normalizePath(p)
    break
  }
}
if (is.null(csv_path)) {
  stop("Cannot find comprehensive_simulation_summary.csv. ",
       "Run this script from the project root or manuscript/ directory.")
}

cat("Reading data from:", csv_path, "\n")
df <- read.csv(csv_path)
cat("Loaded", nrow(df), "scenario rows\n")

# Output directory = same as this script (manuscript/)
out_dir <- script_dir
if (!dir.exists(out_dir)) out_dir <- "."

# --- Color palette ---
method_colors <- c("Naive RE" = "#E41A1C", "Trim & Fill" = "#377EB8",
                   "PET-PEESE" = "#4DAF4A", "Copas" = "#984EA3")

# --- Helper: recode method labels ---
recode_method <- function(x) {
  dplyr::recode(x,
                "naive" = "Naive RE",
                "tf"    = "Trim & Fill",
                "pp"    = "PET-PEESE",
                "copas" = "Copas")
}

# --- Figure 1: Bias ---
bias_df <- df %>%
  select(bias_type, k_scenario, true_effect, true_tau,
         naive_bias, tf_bias, pp_bias, copas_bias) %>%
  pivot_longer(cols = ends_with("_bias"),
               names_to = "method",
               values_to = "bias") %>%
  mutate(method = recode_method(gsub("_bias", "", method)))

p1 <- ggplot(bias_df, aes(x = factor(true_tau), y = bias, fill = method)) +
  geom_boxplot(outlier.size = 0.8, alpha = 0.8) +
  facet_grid(bias_type ~ k_scenario, labeller = labeller(
    k_scenario = function(x) paste0("k = ", x),
    bias_type  = function(x) paste0("Bias: ", x)
  )) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey40") +
  scale_fill_manual(values = method_colors) +
  theme_bw(base_size = 11) +
  theme(legend.position = "bottom",
        strip.background = element_rect(fill = "grey90")) +
  labs(x = expression("Between-study heterogeneity ("*tau*")"),
       y = "Mean Bias",
       fill = "Method")

ggsave(file.path(out_dir, "bias_plot.png"), p1, width = 10, height = 7, dpi = 300)
cat("Saved bias_plot.png\n")

# --- Figure 2: RMSE ---
rmse_df <- df %>%
  select(bias_type, k_scenario, true_effect, true_tau,
         naive_rmse, tf_rmse, pp_rmse, copas_rmse) %>%
  pivot_longer(cols = ends_with("_rmse"),
               names_to = "method",
               values_to = "rmse") %>%
  mutate(method = recode_method(gsub("_rmse", "", method)))

p2 <- ggplot(rmse_df, aes(x = factor(true_tau), y = rmse, fill = method)) +
  geom_bar(stat = "summary", fun = "mean",
           position = position_dodge(width = 0.8), alpha = 0.8) +
  facet_grid(bias_type ~ k_scenario, labeller = labeller(
    k_scenario = function(x) paste0("k = ", x),
    bias_type  = function(x) paste0("Bias: ", x)
  )) +
  scale_fill_manual(values = method_colors) +
  theme_bw(base_size = 11) +
  theme(legend.position = "bottom",
        strip.background = element_rect(fill = "grey90")) +
  labs(x = expression("Between-study heterogeneity ("*tau*")"),
       y = "Mean RMSE",
       fill = "Method")

ggsave(file.path(out_dir, "rmse_plot.png"), p2, width = 10, height = 7, dpi = 300)
cat("Saved rmse_plot.png\n")

# --- Figure 3: Coverage ---
coverage_df <- df %>%
  select(bias_type, k_scenario, true_effect, true_tau,
         naive_coverage, tf_coverage, pp_coverage, copas_coverage) %>%
  pivot_longer(cols = ends_with("_coverage"),
               names_to = "method",
               values_to = "coverage") %>%
  mutate(method = recode_method(gsub("_coverage", "", method)))

p3 <- ggplot(coverage_df, aes(x = factor(true_tau), y = coverage,
                               color = method, group = method)) +
  stat_summary(fun = mean, geom = "line", linewidth = 0.8) +
  stat_summary(fun = mean, geom = "point", size = 2.5) +
  facet_grid(bias_type ~ k_scenario, labeller = labeller(
    k_scenario = function(x) paste0("k = ", x),
    bias_type  = function(x) paste0("Bias: ", x)
  )) +
  geom_hline(yintercept = 0.95, linetype = "dotted", color = "grey40") +
  scale_color_manual(values = method_colors) +
  theme_bw(base_size = 11) +
  theme(legend.position = "bottom",
        strip.background = element_rect(fill = "grey90")) +
  labs(x = expression("Between-study heterogeneity ("*tau*")"),
       y = "95% CI Coverage",
       color = "Method")

ggsave(file.path(out_dir, "coverage_plot.png"), p3, width = 10, height = 7, dpi = 300)
cat("Saved coverage_plot.png\n")

cat("All plots generated successfully.\n")
