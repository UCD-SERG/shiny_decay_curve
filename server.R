
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
      y0 = 10^input$y0,
      y1 = 10^input$y1,
      t1 = 10^input$t1,
      alpha = 10^input$alpha,
      r = 10^input$r) %>%
    reactive()

  # Show the values in an HTML table ----
  output$values <- sliderValues() %>% renderTable()

  # see https://plannapus.github.io/blog/2021-05-27.html:
  session$onFlushed(
    function() shinyjs::runjs("logifySlider('y0', sci = true);"),
    once=FALSE)

  # Limit y1 value to maximum of y0
    updateSliderInput(
      session,
      inputId = "y0",
      max = input$y1) %>%
    observeEvent(eventExpr = input$y1)

  output$plot <-
    {
      serocalculator:::plot_curve_params_one_ab(
        object = sliderValues(),
        n_points = 10^input$n_pts,
        log_x = FALSE,
        log_y = FALSE) +
        scale_y_continuous(limits = c(NA, input$y_max),
                           trans = ifelse(input$log_y, "log10", "identity")) +
        scale_x_continuous(limits = c(1/24, input$x_max),
                           trans = ifelse(input$log_x, "log10", "identity"))
    }%>%
    renderPlot(res = 96)

}
