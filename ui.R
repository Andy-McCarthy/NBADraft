library(shiny)
library(ggvis)

# Download Data
CollegePro <- read.csv("data/NBADraftData.csv")

# Define UI for application that draws a scatterplot
shinyUI(fluidPage(
  
  # Application title
  titlePanel("NBA Draft Data"),
  
  # Sidebar
  sidebarLayout(
    sidebarPanel(
      
      # Drop-down menu to select which stat to examine
      selectInput("skill",
                  label = "Statistic of Interest",
                  choices = c("Points","Rebounds","Assists","Blocks", "Steals"),
                  selected = "Points"),
      
      # Slider for which draft classes to include in the chart
      sliderInput("years",
                  step = 1,
                  label = "Draft Classes",
                  min = min(CollegePro$Draft),
                  max = max(CollegePro$Draft),
                  value = c(min(CollegePro$Draft), max(CollegePro$Draft)),
                  sep = ""),
      
      # Slider for which picks to be included
      sliderInput("pick",
                  step = 1,
                  label = "Pick Number",
                  min = min(CollegePro$Pick),
                  max = max(CollegePro$Pick),
                  value = c(min(CollegePro$Pick), max(CollegePro$Pick))),
      
      # Checkboxes to decide which positions to include
      checkboxGroupInput("position",
                         label = "Position",
                         choices = c("C","PF","SF","SG","PG"),
                         selected = c("C","PF","SF","SG","PG"))
    ),
    
    # Show a scatterplot
    mainPanel(
       ggvisOutput("plot"),
       
       dataTableOutput("table")
    )
  )
  
))
