library(shiny)
library(ggmap)
library(dplyr)
require(ggmap)
# data <- read.csv("globalterrorismdb_0617dist.csv.bz2")
data <- read.csv("United States.csv")

shinyServer(function(input, output) {
   
  output$map <- renderPlot({
    ggmap(get_map(location = input$location, zoom = input$zoom)) +
      geom_point(data = data, aes(x=longitude, y=latitude), alpha = .1, col="black", na.rm = TRUE) +
      ggtitle("Where Terrorism event happens") +
      xlab("longitude") +
      ylab("latitude")
  })
  
  output$mapByType <- renderPlot({
    ggmap(get_map(location = 'United States', zoom = 3)) +
      geom_point(data = data %>% filter(attacktype1_txt == input$typeOfAttack), aes(x=longitude, y=latitude), alpha = .1, col='black', na.rm = TRUE) +
      ggtitle("Type of Attack")
  })
  
  
  #code for attacks in general, and type of attacks
  output$barGraph <- renderPlot({
    btwn70And80 <- filter(data, iyear >= 1970 & iyear < 1980)
    btwn80And90 <- filter(data, iyear >= 1980 & iyear < 1990)
    btwn90And2000 <- filter(data, iyear >= 1990 & iyear < 2000)
    btwn2000And2010 <- filter(data, iyear >= 2000 & iyear < 2010)
    btwn2010And2017 <- filter(data, iyear >= 2010 & iyear < 2017)
    years <- c("70s", "80s", "90s", "2000s", "2010s")
    if (input$typeAttack == "All types") {
      totalCount <- cbind(tally(btwn70And80)$n, tally(btwn80And90)$n, tally(btwn90And2000)$n, tally(btwn2000And2010)$n, tally(btwn2010And2017)$n)
      barplot(totalCount, names.arg = years, col = "red", ylab = "Number of attacks", xlab = "years", main = "Amount of general terrorist attacks by decade")
    } else if (input$typeAttack == "Armed Assault") {
      gunCounts <- cbind(nrow(ezType(btwn70And80, 2)), nrow(ezType(btwn80And90, 2)), nrow(ezType(btwn90And2000, 2)), nrow(ezType(btwn2000And2010, 2)), nrow(ezType(btwn2010And2017, 2)))
      barplot(gunCounts, names.arg = years, col = "gray", ylab = "Number of armed assaults", xlab = "years", main = "Amount of armed assaults by decade")    
    } else if (input$typeAttack == "Explosives") {
      bombCounts <- cbind(nrow(ezType(btwn70And80, 3)), nrow(ezType(btwn80And90, 3)), nrow(ezType(btwn90And2000, 3)), nrow(ezType(btwn2000And2010, 3)), nrow(ezType(btwn2010And2017, 3)))
      barplot(bombCounts, names.arg = years, col = "yellow", border = "orangered", ylab = "Number of bombing/explosive assaults", xlab = "years", main = "Amount of bombing/explosive assaults by decade")    
    } else if (input$typeAttack == "building attack") {
      facCounts <- cbind(nrow(ezType(btwn70And80, 7)), nrow(ezType(btwn80And90, 7)), nrow(ezType(btwn90And2000, 7)), nrow(ezType(btwn2000And2010, 7)), nrow(ezType(btwn2010And2017, 7)))
      barplot(facCounts, names.arg = years, col = "green3", border = "black", ylab = "Number of attacks on buildings/infrastructure", xlab = "years", main = "Amount of building/infrastructure assaults by decade")    
    } else {
      punchCounts <- cbind(nrow(ezType(btwn70And80, 8)), nrow(ezType(btwn80And90, 8)), nrow(ezType(btwn90And2000, 8)), nrow(ezType(btwn2000And2010, 8)), nrow(ezType(btwn2010And2017, 8)))
      barplot(punchCounts, names.arg = years, col = "royalblue2", border = "yellow", ylab = "Number of unarmed assaults", xlab = "years", main = "Amount of unarmed assaults by decade")    
    }
  })
  
})

#Returns a datafram containing data about incidents including attack type inputed as a parameter
ezType <- function(date, type) {
  filter(date, attacktype1 == type | attacktype2 == type | attacktype3 == type)
}
