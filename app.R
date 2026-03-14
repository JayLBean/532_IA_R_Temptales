# Reference: https://shiny.posit.co/r/getstarted/shiny-basics/lesson1/

library(shiny)
library(bslib)
library(DT)
library(dplyr)
library(ggplot2)
library(readr)

source("utils.R", local = FALSE)

# ------------------------------------------------------------------------------
# Data loading
# ------------------------------------------------------------------------------
raw_path <- file.path("data", "raw", "GlobalLandTemperaturesByCountry.csv")
df_raw <- read_climate_data(raw_path)
df_yearly <- build_yearly(df_raw)
df_monthly <- build_monthly(df_raw)
min_year <- min(df_yearly$year)
max_year <- max(df_yearly$year)
country_choices <- sort(unique(df_yearly$Country))

# ------------------------------------------------------------------------------
# UI (inputs in sidebar)
# ------------------------------------------------------------------------------
ui <- page_sidebar(
  title = "TempTales IA - Temperature Comparison",
  sidebar = sidebar(
    selectInput(
      inputId = "country",
      label = "Country",
      choices = country_choices,
      selected = "Canada"
    ),
    numericInput(
      inputId = "base_year",
      label = "Base Year",
      value = 1950,
      min = min_year,
      max = max_year,
      step = 1
    ),
    numericInput(
      inputId = "target_year",
      label = "Target Year",
      value = 2000,
      min = min_year,
      max = max_year,
      step = 1
    ),
    uiOutput("year_validation")
  ),
  plotOutput("line_plot"),
  DTOutput("data_table")
)

# ------------------------------------------------------------------------------
# Server
# ------------------------------------------------------------------------------
server <- function(input, output, session) {
  # Reactive: validate year range
  year_ok <- reactive({
    b <- as.integer(input$base_year)
    t <- as.integer(input$target_year)
    if (is.na(b) || is.na(t)) return(list(ok = FALSE, msg = "Enter valid years"))
    if (b < min_year || b > max_year) return(list(ok = FALSE, msg = paste0("Base year must be ", min_year, "-", max_year)))
    if (t < min_year || t > max_year) return(list(ok = FALSE, msg = paste0("Target year must be ", min_year, "-", max_year)))
    if (t <= b) return(list(ok = FALSE, msg = "Target year must be greater than base year"))
    list(ok = TRUE, base = b, target = t)
  })

  # Output: year validation message
  output$year_validation <- renderUI({
    y <- year_ok()
    if (y$ok) {
      p("Year range is valid.", class = "text-success")
    } else {
      p(y$msg, class = "text-danger")
    }
  })

  # Reactive calc: dataframe with country, year, temp diff (intermediate values)
  reactive_df <- reactive({
    y <- year_ok()
    if (!y$ok) return(NULL)
    country <- req(input$country)
    b <- y$base
    t <- y$target
    df_c <- df_yearly[df_yearly$Country == country, ]
    df_c <- df_c[df_c$year >= b & df_c$year <= t, ]
    if (nrow(df_c) == 0) return(NULL)
    df_c
  })

  # Monthly comparison for line graph (baseline vs target)
  monthly_comparison <- reactive({
    y <- year_ok()
    if (!y$ok) return(NULL)
    country <- req(input$country)
    b <- y$base
    t <- y$target
    df_m <- df_monthly[df_monthly$Country == country & df_monthly$year %in% c(b, t), ]
    if (nrow(df_m) == 0) return(NULL)
    base <- df_m[df_m$year == b, c("month", "AvgTemp")]
    base <- setNames(base, c("month", "base_avg"))
    target <- df_m[df_m$year == t, c("month", "AvgTemp")]
    target <- setNames(target, c("month", "target_avg"))
    mrg <- merge(base, target, by = "month")
    mrg$diff <- round(mrg$target_avg - mrg$base_avg, 2)
    mrg$Month <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")[mrg$month]
    mrg[, c("Month", "month", "base_avg", "target_avg", "diff")]
  })

  # Output: line graph (dual-line monthly temp)
  output$line_plot <- renderPlot({
    m <- monthly_comparison()
    if (is.null(m) || nrow(m) == 0) {
      plot(NULL, xlim = c(1, 12), ylim = c(0, 1), xlab = "Month", ylab = "Temperature (°C)", main = "No data")
      return(invisible(NULL))
    }
    y <- year_ok()
    b <- y$base
    t <- y$target
    chart_data <- rbind(
      data.frame(Month = m$Month, month = m$month, Temperature = m$base_avg,  Year = as.character(b)),
      data.frame(Month = m$Month, month = m$month, Temperature = m$target_avg, Year = as.character(t))
    )
    ggplot(chart_data, aes(x = month, y = Temperature, color = Year, group = Year)) +
      geom_line(linewidth = 1.2) +
      geom_point(size = 3) +
      scale_x_continuous(breaks = 1:12, labels = c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")) +
      labs(
        title = paste0("Temperature Overlay: ", input$country, " (", b, " vs ", t, ")"),
        x = "Month",
        y = "Temperature (°C)"
      ) +
      theme_minimal() +
      theme(
        axis.text.x = element_text(angle = -45, hjust = 0),
        legend.position = "bottom"
      )
  })

  # Output: data table (monthly comparison with temp diff - intermediate values)
  output$data_table <- renderDT({
    m <- monthly_comparison()
    if (is.null(m) || nrow(m) == 0) {
      return(data.frame(Message = "No data for selected country and year range"))
    }
    y <- year_ok()
    out <- data.frame(
      Month = m$Month,
      `Base Year (°C)` = round(m$base_avg, 2),
      `Target Year (°C)` = round(m$target_avg, 2),
      `Temp Diff (°C)` = m$diff
    )
    names(out) <- c("Month", paste0(y$base, " (°C)"), paste0(y$target, " (°C)"), "Temp Diff (°C)")
    out
  })
}

shinyApp(ui = ui, server = server)
