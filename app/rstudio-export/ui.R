library(shiny)
library(plotly)
# Define UI for application that draws a histogram
shinyUI(navbarPage("ORCA-SR",

    # Application title
    tabPanel("3D Visualization",

      # Sidebar with a slider input for number of bins
      sidebarLayout(
          sidebarPanel(
            
              selectInput(inputId = "type",
                          label = "Type of Graph",
                          choices = c("Rene Erdos","P2P-Gnutella"),
                          selected = "P2P-Gnutella"),
              selectInput(inputId = "traffic",
                          label = "Type of Traffic",
                          choices = c("Pareto","Uniform"),
                          selected = "Uniform"),
              selectInput(inputId = "prior",
                          label = "Type of Prior",
                          choices = c("Gravity","Perturbed"),
                          selected = "Gravity"),
              numericInput(inputId = "node",
                           label = "Number of Nodes",
                           min = 1,
                           max = 10000,
                           value = 100),
              selectInput(inputId = "threshold",
                          label = "Threshold",
                          choices = c("SD_Pair/10","SD_Pair/100", "SD_Pair/1000", "SD_Pair/100000"),
                          selected = "Red"),
              submitButton(text = "Generate Network", icon = NULL, width = NULL),
              # Horizontal line ----
              tags$hr(),
              fileInput("file1", "Choose Edge (.csv)",
                        multiple = FALSE,
                        accept = c("text/csv",
                                   "text/comma-separated-values,text/plain",
                                   ".csv")),
              fileInput("file1", "Choose Traffic (.csv)",
                        multiple = FALSE,
                        accept = c("text/csv",
                                   "text/comma-separated-values,text/plain",
                                   ".csv")),
              fileInput("file1", "Choose Prior (.csv)",
                        multiple = FALSE,
                        accept = c("text/csv",
                                   "text/comma-separated-values,text/plain",
                                   ".csv")),
              submitButton(text = "Generate Network", icon = NULL, width = NULL)
          ),
          
  
          # Show a plot of the generated distribution
          mainPanel(
          plotlyOutput("distPlot")
          ))
    ),
    tabPanel("SD Flows",
              dataTableOutput("test")
    ),
    tabPanel("SD Subsetting",
              plotOutput("plot2", height = 300,
                         dblclick = "plot_dblclick",
                            brush = brushOpts(
                              id = "plot1_brush")),
                fluidRow(
                  # column(width = 6,
                  #        h4("Points near click"),
                  #        verbatimTextOutput("click_info")
                  # ),
                  column(width = 12,
                         h4("Selected Flows"),
                         verbatimTextOutput("brush_info")
                  )
                )
    ),
    tabPanel("Threshold"
             # mainPanel(
             #   column(6,
             #          plotlyOutput("heatmap",height = "700px",width = "700px")),
             #   column(6,
             #          plotlyOutput("heatmap2",height = "700px",width = "700px")))

    )
))
