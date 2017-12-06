library(dplyr)
library(ggplot2)
library(shiny)
library(shinythemes)

shinyUI(navbarPage(theme = shinytheme("cerulean"), "Terrorism in the United States",
     tabPanel("Where it happens",
        sidebarLayout(
          sidebarPanel(
            textInput("location", label = h3("Which location would you like to explore?"), value = "Washington"),
            
            hr(),
            
            sliderInput("zoom", label = h3("Zoom"), min = 3, 
                        max = 20, value = 6)
          ),
          
          # Main panel displaying outputs
          mainPanel(
            plotOutput("map")
          )
        )),
     tabPanel("Amount of Attacks",
              sidebarLayout(
                sidebarPanel(
                  radioButtons("typeAttack", label = h3("Choose a Type of Terrorist Attack"), selected = "All types",
                               choices = list("All types" = "All types", 
                                              "Armed Assault" = "Armed Assault", 
                                              "Explosives" = "Explosives",
                                              "Facility/Infrastructure attack" = "building attack", 
                                              "Unarmed Assault" = "Unarmed Assault"))
                ),
                mainPanel(
                  plotOutput("barGraph")
                )
              )
              
              ),
     tabPanel("Type Of Attack",
              sidebarLayout(
                sidebarPanel(
                  checkboxGroupInput("typeOfAttack", label = h3("Select Type of Attack"),
                                     choices = list("Armed Assault" = 'Armed Assault', "Explosives" = 'Explosives', "Facility/Infrastructure attack" = 'building attack', "Unarmed Assault" = 'Unarmed Assault'), selected = c("Armed Assault","Explosives", "Facility/Infrastructure attack", "Unarmed Assault"))                  
                ),
                mainPanel(
                  plotOutput("mapByType")
                )
              )
              
              ),
     tabPanel("Attacks by Nationality",
                mainPanel(
                  plotOutput("nationality")
                )
              ),
     tabPanel("Documentation",
                mainPanel(
                includeHTML("documentation.html")
                )
              )
     
  )
)
