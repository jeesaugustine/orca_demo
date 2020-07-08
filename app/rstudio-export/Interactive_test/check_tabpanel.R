shinyApp(
  shinyUI(
    fluidPage(
      mainPanel(
        tabsetPanel(
          tabPanel("Summary", dataTableOutput("dis")),
          tabPanel("Plot",
                   # fluidRow(...)
                   plotOutput("plot1"),
                   plotOutput("plot2",click = "point_click"),
                   verbatimTextOutput("test")
          )
        )
      )
    )
  ),
  shinyServer(function(input, output) {
    output$plot1 <- renderPlot({
      plot(1:10, 1:10)
    })
    
    output$plot2 <- renderPlot({
      plot(1:10 ,10:1)
    })

    output$test <- renderPrint({input$point_click})
    
    output$dis <- renderDataTable({})
  })
)
