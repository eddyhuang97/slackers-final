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
      ggtitle("Where Terrorism Events Happen in the U.S.") +
      xlab("longitude") +
      ylab("latitude")
  })
  
  output$mapByType <- renderPlot({
    ggmap(get_map(location = 'United States', zoom = 3)) +
      geom_point(data = data %>% filter(attacktype1_txt == input$typeOfAttack), aes(x=longitude, y=latitude), alpha = .1, col='black', na.rm = TRUE) +
      ggtitle("Types of Attacks")
  })
  
  # Outputs a plot of attacks by nationality
  output$nationality <- renderPlot({
    # Sets up all the data about terrorist attacks  
    nationalities <- data %>% distinct(natlty1_txt)
    nationalities[nationalities==""]<-NA
    nationalities <- na.omit(nationalities, cols=seq_along(nationalities), invert=FALSE)
    nationalities$num_attacks <- NA
    rownames(nationalities) <- 1:nrow(nationalities)
    # Adds all the number of attacks based on each nationality to own dataframe (excluding all attacks that didn't have nationality provided)
    for (row in 1:nrow(nationalities)) {
      nationality <- nationalities[row, "natlty1_txt"]
      attacks_sum <- sum(data$natlty1_txt == nationality)
      nationalities$num_attacks[nationalities$natlty1_txt == nationality] <- attacks_sum
    }
    plot <- ggplot(nationalities, aes(x = nationalities$natlty1_txt, y = nationalities$num_attacks, color = nationalities$natlty1_txt)) + 
      geom_point(size = 4) +
      theme(axis.text.x = element_text(angle = 90, hjust = 1), legend.position = "none") +
      ggtitle("Number of Attacks in the U.S. by Nationality") +
      theme(axis.text.y = element_text(angle = 0, hjust = 1)) +
      title(line = 3) +
      xlab("Number of Attacks") +
      ylab("Nationality")
    print(plot)
  }, height = 700, width = 1200)
  # height = 1000
  
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
