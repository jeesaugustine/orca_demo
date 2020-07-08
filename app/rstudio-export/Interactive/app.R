library(shiny)

server <- function(input,output, session) {
  
  library(DT) 
  library(ggplot2) 
  
  
  file_reader <- read.csv(file = "output.txt", header = FALSE)
  transpose_step1 <- melt(file_reader)
  transpose_table <- as.data.frame(transpose_step1$value)
  colnames(transpose_table) <- c("traffic")
  transpose_table$flow_id <- cbind(c(1:length(transpose_table$traffic)))
  
  
  mod <- transpose_table
  
  output$plot <- renderPlot({
    ggplot(mod, aes(flow_id, traffic)) + geom_point(shape=23, color="grey50") +geom_rug()
  })
  
  dat <- reactive({
    user_brush <- input$user_brush
    brushedPoints(mod, user_brush, xvar = "flow_id", yvar = "traffic")
  })
  
  output$table <- DT::renderDataTable({DT::datatable(dat())})
  
  output$mydownload <- downloadHandler(
    filename = "plotextract.csv",
    content = function(file) {write.csv(dat(), file)}
  )
}

ui <- fluidPage(
  h3("Subsetting the Network"),
  plotOutput("plot", brush = "user_brush"),
  dataTableOutput("table"),
  h3("Download Flow Data"),
  downloadButton(outputId = "mydownload", label = "Download Table")
)

shinyApp(ui = ui, server = server)