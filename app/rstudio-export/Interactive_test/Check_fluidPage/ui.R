#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
# Define UI for application that draws a histogram
shinyUI(fluidPage
        (mainPanel
          (tabsetPanel
            (
                   # Application title
                   tabPanel("Network Visualization",
                            
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
                                             value = 2),
                                selectInput(inputId = "color",
                                            label = "Type of Color",
                                            choices = c("Red","Green"),
                                            selected = "Red"),
                                submitButton(text = "Apply Changes", icon = NULL, width = NULL)
                              ),
                              
                              
                              # Show a plot of the generated distribution
                                plotlyOutput("distPlot")
                              )
                   ),
                   tabPanel("Traffic",
                            dataTableOutput("test")
                   ),
                   tabPanel("Interactive",
                            plotOutput("plot2", click = "plot_click"),
                            verbatimTextOutput("test")
                              
                   )
))))
