# from https://forum.posit.co/t/keep-ui-formatting-when-updating-slider-value/48552/2

library(shiny)

#############################
calculate_C0 <- function(){
  C0 = 10^runif(1, min = 5, max = 20)
  return(C0)
}

#############################
# expSlider javascript function
JS.expify <-
  "
// function to exponentiate a sliderInput
function expSlider (sliderId, sci = false) {
$('#'+sliderId).data('ionRangeSlider').update({
'prettify': function (num) { return ('10<sup>'+num+'</sup>'); }
})
}"

# call expSlider for each relevant sliderInput
JS.onload <-
  "
// execute upon document loading
$(document).ready(function() {
// wait a few ms to allow other scripts to execute
setTimeout(function() {
// include call for each slider
expSlider('logC0', sci = true)
}, 5);
$('#C0_widget_setval').click(function() {
expSlider('logC0', sci = true)
})})
"

###########################################################
ui <- fluidPage(withMathJax(),
                tags$head(tags$script(HTML(JS.expify))),
                tags$head(tags$script(HTML(JS.onload))),
                sliderInput("logC0", label = "Initial resource concentration \\(C_0\\)",
                            min = 5, max = 20, value = 12, step = 0.5, width = "50%"),
                htmlOutput("C0_widget_out"),
                br(),
                br(),
                actionButton("C0_widget_setval", "Set this value")

) #fluidpage

###########################################################
server <- function(input, output, session) {

  ## C0 widget ----
  suggested_C0 <- reactive({
    suggested_C0  <- calculate_C0()
    return(suggested_C0)
  })

  output$C0_widget_out <- reactive({
    HTML('Suggested C0: 10<sup>', round(log10(suggested_C0()), digits = 1),'</sup>' )
  })

  observeEvent(input$C0_widget_setval, {
    # Control the value of C0
    updateSliderInput(session, "logC0", value = log10(suggested_C0()))
  })

}

###########################################################
shinyApp(ui = ui, server = server)
