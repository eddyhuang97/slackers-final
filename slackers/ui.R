library(dplyr)
library(ggplot2)
library(shiny)

shinyUI(navbarPage("Terrorism in the United States",
     tabPanel("The Map",
        sidebarLayout(
          sidebarPanel(
            textInput("location", label = h3("Which Location would you like to explore?"), value = "Washington"),
            
            hr(),
            
            sliderInput("zoom", label = h3("Zoom"), min = 3, 
                        max = 20, value = 6)
          ),
          
          # Main panel displaying output
          mainPanel(
            plotOutput("map")
          )
        )),
     tabPanel("The Bar graph"),
     tabPanel("Other stuff ... just rename this guys")
  )
)
