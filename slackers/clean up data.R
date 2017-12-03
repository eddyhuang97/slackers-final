require(dplyr)

read.csv("globalterrorismdb_0617dist.csv.bz2") %>%
  filter(country_txt == "United States") %>%
  write.csv("United States.csv")

