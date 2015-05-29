# Load Packages
library(shiny)
library(gsheet)
library(plyr)

# Google Docs URL
url_data <- "https://docs.google.com/spreadsheets/d/1gtXZEVYbxdpKs7V3IEJoM1k0mwS_pstN2kQcFWHZ9J0/edit?usp=sharing"
url_schedule <- "https://docs.google.com/spreadsheets/d/1QWmCqqtWjdNR2NBoS-G7aoNNPlzzvz0-oeppez1Nvs4/edit?usp=sharing"

# Load Data, only games that have been played
data <- gsheet2tbl(url = url_data)
data <- data[data$Complete == "Y", ]
# data
schedule <- gsheet2tbl(url = url_schedule)

# Create Standings Table
standings <- ddply(data, .(TeamName), summarise,
                   Wins = sum(Win),
                   Losses = length(TeamName[Win == 0]),
                   Runs = sum(RunScored)
)
standings <- standings[order(-standings$Wins, -standings$Runs), ]

#shiny app
ui <- fluidPage(
  titlePanel("2015 Burt Men's Softball Schedule and Standings"),
  tableOutput("schedule"),
  tableOutput("standings")
)

server <- function(input, output) {
  output$schedule <- renderTable({
    schedule
  }, include.rownames = FALSE)
  
  output$standings <- renderTable({
    standings
  }, include.rownames = FALSE)
}

shinyApp(ui = ui, server = server)