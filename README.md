# 532_IA — TempTales Individual Assignment (Shiny for R)

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

## Deployment to Posit Connect Cloud

For deployment to Posit Connect Cloud, generate a `manifest.json` file so Connect knows which R packages to install:

```r
# From the 532_IA directory
rsconnect::writeManifest()
```

Then deploy via the Posit Connect web interface or `rsconnect` package. Ensure `manifest.json` is committed to your GitHub repository.

## Deployed App

*(Add your Posit Connect Cloud URL here after deployment. The assignment requires linking this in the repository About section.)*

## License

Same as the parent 532 project.
