library(shiny)
library(shinyWidgets)
ui <- fluidPage(
  shinyWidgets::sliderTextInput(
    "pvalue2","PValue:",
    choices = (10^(seq(-4,4, by = .1))) |> signif(1),
    selected = 10^0, grid = T)
)
server <- function(input, output) {}
shinyApp(ui, server)
