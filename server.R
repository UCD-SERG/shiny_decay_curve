
# Load required script
library(serocalculator)
library(scales)
library(shiny)
library(shinyWidgets)

# Define server logic for slider examples ----
server <- function(input, output,session) {

  # Reactive expression to create data frame of all input values ----
  sliderValues <-
    data.frame(
      y0 = input$y0,
      y1 = 10^input$y1,
      t1 = input$t1,
      alpha = 10^input$alpha,
      r = input$r) |>
    reactive()

  # Show the values in an HTML table ----
  output$values <- sliderValues() |> renderTable()

  # Limit y1 value to maximum of y0
  updateSliderInput(
    session,
    inputId = "y0",
    max = input$y1) |>
  observeEvent(eventExpr = input$y0)

output$plot <-
  serocalculator:::plot_curve_params_one_ab(
    object = sliderValues(),
    xlim = c(1/24, max(100, input$t1*2)),
    n_points = 10^input$n_pts,
    log_x = input$log_x,
    log_y = input$log_y) |>
  renderPlot(res = 96)

}
