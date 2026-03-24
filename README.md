# Publication Bias Adjustment Methods: A Comprehensive Simulation Study

A simulation study comparing the performance of three widely used publication bias correction methods -- Trim and Fill, PET-PEESE, and the Copas selection model -- across 135 scenarios spanning realistic meta-analytic conditions.

## Key Findings

- **PET-PEESE** frequently overcorrects under heterogeneity (tau >= 0.3), producing negatively biased estimates and poor coverage.
- **Trim and Fill** performs well in low-heterogeneity settings but provides insufficient correction when heterogeneity is substantial.
- **Copas selection model** achieves the lowest RMSE across most conditions when k >= 20, but convergence can be imperfect with small study counts.
- **No single method is universally superior.** Researchers should report results from multiple adjustment methods.

## Project Structure

```
pub-bias-simulation/
|-- manuscript/
|   |-- manuscript.Rmd          # Main manuscript (R Markdown)
|   |-- references.bib          # BibTeX references
|   |-- generate_plots.R        # Standalone figure generation script
|   +-- README.md               # Manuscript reproduction guide
|-- R/                          # R package source (simulation functions)
|-- supplementary/
|   +-- standardized/           # 65 standardized meta-analytic datasets
|-- comprehensive_simulation_summary.csv   # 135-row scenario summary (main analysis file)
|-- comprehensive_simulation_raw.csv       # 13,480-row individual simulation results
|-- comprehensive_simulation_raw.rds       # Same as above in RDS format
|-- simulation_full_results.csv            # 1,600-row preliminary simulation results
|-- simulation_summary.csv                 # 16-row preliminary summary
|-- DESCRIPTION                            # R package metadata
|-- renv.lock                              # Reproducible R environment
+-- .gitignore
```

## Simulation Design

Full factorial design with:
- **True effect size (theta):** 0.3, 0.5, 0.8 (standardized mean difference)
- **Number of studies (k):** 10, 20, 50
- **Between-study heterogeneity (tau):** 0.1, 0.3, 0.5
- **Bias mechanism:** Continuous selection, threshold-based, combined

135 unique conditions, approximately 100 replications each (13,480 total simulated meta-analyses).

## Methods Compared

| Method | Description |
|--------|-------------|
| Naive RE | Standard DerSimonian-Laird random-effects (no adjustment) |
| Trim and Fill | Funnel plot augmentation (L0 estimator) |
| PET-PEESE | Conditional meta-regression on SE/variance |
| Copas | Maximum likelihood selection model |

## Performance Metrics

- Mean bias
- Root mean square error (RMSE)
- Mean absolute error (MAE)
- 95% CI coverage
- Convergence rate

## Reproducing the Analysis

### Prerequisites

- R >= 4.1.0
- Required packages: `metafor`, `metasens`, `ggplot2`, `dplyr`, `tidyr`, `rmarkdown`, `knitr`

### Using renv (recommended)

```r
# Restore the exact package versions used in this study
renv::restore()
```

### Generate Figures

```r
# From the project root:
source("manuscript/generate_plots.R")

# Or from the manuscript/ directory:
setwd("manuscript")
source("generate_plots.R")
```

### Render the Manuscript

```r
rmarkdown::render("manuscript/manuscript.Rmd")
```

## Data Files

| File | Rows | Description |
|------|------|-------------|
| `comprehensive_simulation_summary.csv` | 135 | Scenario-level summary statistics (primary analysis file) |
| `comprehensive_simulation_raw.csv` | 13,480 | Individual simulation results |
| `comprehensive_simulation_raw.rds` | 13,480 | Same data in R binary format |
| `simulation_full_results.csv` | 1,600 | Preliminary simulation (subset of conditions) |
| `simulation_summary.csv` | 16 | Preliminary summary |

## Author

Mahmood Ahmad

## License

MIT
