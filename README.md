# 532_IA — TempTales Individual Assignment (Shiny for R)

| | |
| :--- | :--- |
| **License** | [![License](https://img.shields.io/github/license/JayLBean/532_IA_R_Temptales?label=License)](LICENSE) |
| **R** | [![R](https://img.shields.io/badge/R-4.0+-276DC3.svg)](https://www.r-project.org/) |
| **Status** | [![Repo Status](https://img.shields.io/badge/repo%20status-Active-brightgreen)](https://github.com/JayLBean/532_IA_R_Temptales) |

Minimal Shiny for R re-implementation of the TempTales climate dashboard (Python/Shiny). This app allows users to compare temperature trends for a selected country between a base year and a target year.

## Purpose

This application re-implements the core functionality of the 532 TempTales group project in **Shiny for R**:

- **Inputs**: Country selector, base year, target year
- **Reactive calc**: A dataframe containing the selected country's yearly data and monthly temperature difference (intermediate values)
- **Outputs**: A line graph showing monthly temperature overlay (base vs target year) and a data table with monthly comparison including temperature difference

## Project Structure

```
532_IA/
├── app.R              # Main Shiny application (UI, server, reactive calc)
├── utils.R            # Data loading and preprocessing (read_climate_data, build_yearly, build_monthly)
├── data/
│   └── raw/           # Raw data (GlobalLandTemperaturesByCountry.csv)
├── manifest.json      # Dependency manifest for Posit Connect deployment
├── README.md          # This file
├── install.R          # Package installation script for Posit Connect / local use
└── .gitignore
```

## Installation

From R or RStudio, run:

```r
install.packages(c("shiny", "bslib", "DT", "dplyr", "ggplot2", "readr"))
```

Or use the included `install.R` script:

```r
source("install.R")
```

## Running the App

### Local

From R or RStudio:

```r
library(shiny)
runApp("532_IA")
```

Or, if your working directory is already `532_IA`:

```r
runApp()
```

### RStudio

1. Open `app.R` in RStudio
2. Click the **Run App** button (or press Cmd+Shift+Enter / Ctrl+Shift+Enter)


## Deployed App

<https://jaylbean-532-ia-r-temptales.share.connect.posit.cloud/>

## Copyright

- Copyright © 2026 Master of Data Science at the University of British Columbia.
- Free software distributed under the [MIT License](./LICENSE).
