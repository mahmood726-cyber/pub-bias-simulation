# Manuscript Reproduction Guide

This directory contains the manuscript and the scripts needed to reproduce all figures and tables.

## Contents

- `manuscript.Rmd` -- Main manuscript in R Markdown format. Self-contained: figures are generated inline via embedded R code chunks.
- `references.bib` -- BibTeX file with all cited references.
- `generate_plots.R` -- Standalone R script to generate figures as PNG files (useful for previewing without knitting the full manuscript).

## Quick Start

### Option 1: Knit the manuscript (recommended)

The manuscript contains embedded R code that generates all figures and tables automatically:

```r
rmarkdown::render("manuscript.Rmd")
```

This produces `manuscript.html` (default), or specify output format:

```r
rmarkdown::render("manuscript.Rmd", output_format = "pdf_document")
rmarkdown::render("manuscript.Rmd", output_format = "word_document")
```

### Option 2: Generate standalone figures

```r
source("generate_plots.R")
```

This creates `bias_plot.png`, `rmse_plot.png`, and `coverage_plot.png` in this directory.

## Dependencies

- R >= 4.1.0
- `ggplot2`, `dplyr`, `tidyr` (for figures)
- `rmarkdown`, `knitr` (for rendering)

## Data Source

All figures use `../comprehensive_simulation_summary.csv` (135 scenario-level summary rows) from the project root.

## Citation Style

The manuscript uses the default Pandoc citation processor with `references.bib`. To use Vancouver style (numbered references), place a `vancouver.csl` file in this directory and it will be picked up automatically. Without the CSL file, Pandoc uses its default author-year style.
