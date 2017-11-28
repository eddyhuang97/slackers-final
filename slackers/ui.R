library(dplyr)
library(ggplot2)
library(shiny)

shinyUI(fluidPage(
  # Title of the application
  titlePanel("Slackers"),
  
  # Sidebar
  sidebarLayout(
    sidebarPanel(
       sliderInput("bins",
                   "Number of bins:",
                   min = 1,
                   max = 50,
                   value = 30)
    ),
    
    # Main panel displaying output
    mainPanel(
       plotOutput("distPlot")
    )
  )
))
