library(ggplot2)
library(Cairo)   # For nicer ggplot2 output when deployed on Linux
library(shiny)
# We'll use a subset of the mtcars data set, with fewer columns
# so that it prints nicel

shinyUI(fluidPage(
  fluidRow(
    column(width = 4,
           plotOutput("plot1", height = 300,
                      # Equivalent to: click = clickOpts(id = "plot_click")
                      click = "plot1_click",
                      brush = brushOpts(
                        id = "plot1_brush"
                      )
           )
    )
  ),
  fluidRow(
    # column(width = 6,
    #        h4("Points near click"),
    #        verbatimTextOutput("click_info")
    # ),
    column(width = 6,
           h4("Brushed points"),
           verbatimTextOutput("brush_info")
    )
  )
)
)