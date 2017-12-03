library(shiny)
require(ggmap)
# data <- read.csv("globalterrorismdb_0617dist.csv.bz2")
data <- read.csv("United States.csv")

shinyServer(function(input, output) {
   
  output$map <- renderPlot({
    ggmap(get_map(location = input$location, zoom = input$zoom)) +
      geom_point(data = data, aes(x=longitude, y=latitude), alpha = .1, col='black', na.rm = TRUE) +
      ggtitle("Where Terrorism event happens") +
      xlab("longitude") +
      ylab("latitude")
  })
  
})
