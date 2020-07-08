library(shiny)
require(heatmaply)
ui <- basicPage(
  plotlyOutput("heatmap",height = "800px",width = "800px")
)
server <- function(input, output) {
  mat <- read.csv("aat.csv", header = FALSE)
  # print(mat)
  output$heatmap <- renderPlotly(heatmaply(mat, Rowv = FALSE, Colv = FALSE, margins = c(40,40,40,40), showticklabels = FALSE,scale_fill_gradient_fun = ggplot2::scale_fill_gradient2(low = "white", high = "red"),hide_colorbar=TRUE))
}

shinyApp(ui, server)