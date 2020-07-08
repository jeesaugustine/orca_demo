
library(shiny)
mtcars2 <- mtcars[, c("mpg", "cyl", "disp", "hp", "wt", "am", "gear")]

shinyServer(function(input, output) {
  output$plot1 <- renderPlot({
    ggplot(mtcars2, aes(wt, mpg)) + geom_point()
  })
  
  # output$click_info <- renderPrint({
  #   # Because it's a ggplot2, we don't need to supply xvar or yvar; if this
  #   # were a base graphics plot, we'd need those.
  #   nearPoints(mtcars2, input$plot1_click, addDist = TRUE)
  #   print(input$plot1_click)
  # })
  k = 0
  output$brush_info <- renderPrint({
    print('hi')
    # print(input)
    k <- k+1
    # print(k)
    print(input$plot1_brush)
    brushedPoints(mtcars2, input$plot1_brush)
  })
})