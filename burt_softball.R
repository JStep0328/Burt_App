# Load Packages
library(gsheet)
library(plyr)

# Google Docs URL
url <- "https://docs.google.com/spreadsheets/d/1gtXZEVYbxdpKs7V3IEJoM1k0mwS_pstN2kQcFWHZ9J0/edit?usp=sharing"

# Load Data, only games that have been played
data <- gsheet2tbl(url = url)
data <- data[data$Complete == "Y", ]

# Create Standings Table
standings <- ddply(data, .(TeamName), summarise,
      Wins = sum(Win),
      RunScored = sum(RunScored)
)
standings <- standings[order(-standings$Wins, -standings$RunScored), ]
standings