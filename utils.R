# Data loading and preprocessing utilities

read_climate_data <- function(raw_path) {
  if (!file.exists(raw_path)) {
    return(NULL)
  }
  df <- read_csv(
    raw_path,
    col_types = cols(
      dt = col_date(),
      AverageTemperature = col_double(),
      AverageTemperatureUncertainty = col_double(),
      Country = col_character()
    ),
    show_col_types = FALSE
  )
  df <- df[complete.cases(df[, c("AverageTemperature", "Country")]), ]
  df$year <- as.integer(format(df$dt, "%Y"))
  df$month <- as.integer(format(df$dt, "%m"))
  df <- df[df$year >= 1860L & df$year <= 2012L, ]
  df
}

build_yearly <- function(df) {
  if (is.null(df) || nrow(df) == 0) return(NULL)
  df |>
    group_by(year, Country) |>
    summarise(avg_temp = mean(AverageTemperature, na.rm = TRUE), .groups = "drop")
}

build_monthly <- function(df) {
  if (is.null(df) || nrow(df) == 0) return(NULL)
  df |>
    group_by(year, Country, month) |>
    summarise(AvgTemp = mean(AverageTemperature, na.rm = TRUE), .groups = "drop")
}
