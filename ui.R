
# load libraries
library(ggplot2)
library(magrittr)

# logifySlider javascript function
JS.logify <-
  "
// function to logify a sliderInput
function logifySlider (sliderId, sci = false) {
  if (sci) {
    // scientific style
    $('#'+sliderId).data('ionRangeSlider').update({
      'prettify': function (num) { return ('10<sup>'+num+'</sup>'); }
    })
  } else {
    // regular number style
    $('#'+sliderId).data('ionRangeSlider').update({
      'prettify': function (num) { return (Math.pow(10, num)); }
    })
  }
}"

# call logifySlider for each relevant sliderInput
JS.onload <-
  "
// execute upon document loading
$(document).ready(function() {
  // wait a few ms to allow other scripts to execute
  setTimeout(function() {
    // include call for each slider
logifySlider('y1', sci = false)
logifySlider('alpha', sci = false)
    logifySlider('r', sci = false)
  }, 5)})
"
# Define UI for app --
ui <- fluidPage(

  # App title ----
  titlePanel("Serocalculator: Interactive Antibody Kinetic Model"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar to demonstrate various slider options ----
    sidebarPanel(

      tags$head(tags$script(HTML(JS.logify))),
      tags$head(tags$script(HTML(JS.onload))),


      sliderInput("y0", "Baseline antibody concentration (y0):",
                  min = .01, max = 100,
                  value = 1,step = 0.01),

      # Input: Decimal interval with step value ----
      sliderInput("y1", "Peak antibody concentration (y1):",
                  min = 2, max = 6,
                  value = 4, step = .01),

      # Input: Specification of range within an interval ----
      sliderInput("t1", "Time to peak antibody concentration (t1):",
                  min = 0.0, max = 200,
                  value = 9.51, step = 0.125),

      # Input: Custom currency format for with basic animation ----
      sliderInput("alpha", "Antibody decay rate in days (alpha):",
                  min = 10^-8, max = 10^0, # 0.0001
                  value = 0.1, step = 0.0001),

      # Input: Animation
      sliderInput("r", "Antibody decay shape (r):",
                  min = 1.0, max = 3,
                  value = 1.7, step = 0.01),

      sliderInput("n_pts", "# curve graphing points:",
                  min = 10, max = 10000,
                  value = 1000, step = 1),

      br()
    ),

    # Main panel for displaying outputs ----
    mainPanel(

      # Output: Table summarizing the values entered ----
      shiny::checkboxInput(
        inputId = "log_y",
        label = "logarithmic y-axis",
        value = FALSE),
      plotOutput("plot", click = NULL),
      shiny::checkboxInput(
        inputId = "log_x",
        label = "logarithmic x-axis",
        value = FALSE) |>
        shiny::column(offset = 8, width = 4) |>
        shiny::fluidRow(),
      tableOutput("values")

    )
  )
)
