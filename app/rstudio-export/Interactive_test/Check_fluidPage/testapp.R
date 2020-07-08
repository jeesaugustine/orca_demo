shinyApp(
# Define UI for application that draws a histogram
shinyUI(fluidPage
        (mainPanel
          (tabsetPanel
            (
              
              tabPanel("Interactive",
                       plotOutput("plot2", click = "plot_click"),
                       verbatimTextOutput("test")

              ),
              tabPanel("Traffic",
                       dataTableOutput("test"))
            )))),
shinyServer(function(input, output) {
  
  library(plotly)
  library(igraph)
  library(reshape2)
  library(shiny)

  #####################################################################################################################################################################    
  
  ##### Tab 3 ######    
  
  #####################################################################################################################################################################    
  library(Cairo)
  library(ggplot2)
  mtcars2 <- mtcars[, c("mpg", "cyl", "disp", "hp", "wt", "am", "gear")]
  output$plot2 <- renderPlot({
    ggplot(mtcars2, aes(wt, mpg)) + geom_point()
  })
  # output$click_info <- renderPrint({
  #   # Because it's a ggplot2, we don't need to supply xvar or yvar; if this
  #   # were a base graphics plot, we'd need those.
  #   nearPoints(mtcars2, input$plot_click, addDist = TRUE)
  #   brushedPoints(mtcars2, input$plot1_brush)
  # })
  output$test <- renderPrint({
    #print('Hi')
    input$plot_click
    #print(input$plot1_click)
    #brushedPoints(mtcars2, input$plot1_brush)
    # brushedPoints(mtcars2)
  })
  output$test <- renderDataTable({
    library(kableExtra)
    library(DT)
    library(Cairo)
    
    file_reader <- read.csv(file = "output.txt", header = FALSE)
    transpose_step1 <- melt(file_reader)
    transpose_table <- as.data.frame(transpose_step1$value)
    colnames(transpose_table) <- c("Traffic")
    transpose_table$col2 <- cbind(c(1:length(transpose_table$Traffic)))
    datatable(transpose_table, filter = 'top', options = list(pageLength = 5))
  })
  
  
  #####################################################################################################################################################################    
  
  ##### Tab 2 ######    
  
  #####################################################################################################################################################################            
  
})


)
