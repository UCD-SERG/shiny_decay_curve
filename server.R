
# Load required script
library(serocalculator)

# Define server logic for slider examples ----
server <- function(input, output,session) {

  # Reactive expression to create data frame of all input values ----
  sliderValues <- reactive({

    data.frame(

      matrix(data = c(input$y0,
                      input$y1,
                      input$t1,
                      input$alpha,
                      input$r),nrow = 1,ncol = 5) %>%
        set_colnames(c("y0",
                       "y1",
                       "t1",
                       "alpha",
                       "r"))
    )
  })

  # Show the values in an HTML table ----
  output$values <- renderTable({
    sliderValues()
  })

  # Limit y1 value to maximum of y0
  observeEvent(input$y1, {
    updateSliderInput(session,inputId = "y0", max = input$y1)
  })

  output$plot <- renderPlot({
    # plot curve
    p = serocalculator:::plot_curve_params_one_ab(object = sliderValues())
    print(p)
  }, res = 96)
}
