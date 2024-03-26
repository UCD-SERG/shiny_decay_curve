
# load libraries
library(ggplot2)
library(magrittr)

# logifySlider javascript function
JS.logify <-
  "
// function to logify a sliderInput
function logifySlider (sliderId, sci = false, sigfig = 4) {
  if (sci) {
    // scientific style
    $('#'+sliderId).data('ionRangeSlider').update({
      'prettify': function (num) { return ('10<sup>'+num+'</sup>'); }
    })
  } else {
    // regular number style
    $('#'+sliderId).data('ionRangeSlider').update({
      'prettify': function (num) { return (Number.parseFloat(Math.pow(10, num)).toFixed(sigfig)); }
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
logifySlider('y0', sci = true)
logifySlider('y1', sci = true)
logifySlider('alpha', sci = false)
logifySlider('r', sci = false)
logifySlider('n_pts', sci = false, sigfig = 0)
  }, 5);
$('#y1').click(function() {
logifySlider('y0', sci = true)
})
})
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
                  min = .001 |> log10(),
                  max = 1000 |> log10(),
                  value = 10 |> log10(),
                  step = 0.01),

      # Input: Decimal interval with step value ----
      sliderInput("y1", "Peak antibody concentration (y1):",
                  min = 100 |> log10(),
                  max = (10^6) |> log10(),
                  value = 10000 |> log10(),
                  step = .01),

      # Input: Specification of range within an interval ----
      sliderInput("t1", "Time to peak antibody concentration (t1):",
                  min = 0.0, max = 200,
                  value = 9.51, step = 0.125),

      # Input: Custom currency format for with basic animation ----
      sliderInput("alpha",
                  "Antibody decay rate in days (alpha):",
                  min = 0.0001 |> log10(),
                  max = 1 |> log10(),
                  value = 0.1 |> log10(),
                  step = 0.01),

      # Input: Animation
      sliderInput("r", "Antibody decay shape (r):",
                  min = 1.0, max = 3,
                  value = 1.7, step = 0.01),

      sliderInput("n_pts", "# curve graphing points:",
                  min = 1,
                  max = 6,
                  value = 3,
                  step = .5,
                  round = TRUE),

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
