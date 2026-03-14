# Install required R packages for 532_IA
# Run: source("install.R") or Rscript install.R

packages <- c("shiny", "bslib", "DT", "dplyr", "ggplot2", "readr")
for (pkg in packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, repos = "https://cloud.r-project.org")
  }
}
