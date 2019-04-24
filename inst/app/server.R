library(shiny)
library(tidyverse)

# Download Data
CollegePro <- read.csv("data/NBADraftData.csv")
# Clean up first column name
colnames(CollegePro)[1] <- "Draft"

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
   
  vis <- reactive({
    
    # Subset the data frame by draft years selected
    ProCollege <- filter(CollegePro, Draft >= input$years[1], Draft <= input$years[2])
    
    # Subset the data frame by position
    ProCollege <- filter(ProCollege, POS %in% input$position)
    
    # Subset the data frame by pick number
    ProCollege <- filter(ProCollege, Pick >= input$pick[1], Pick <= input$pick[2])
    
    # Show Player's name when hovered over
    player_tooltip <- function(x) {
      if (is.null(x)) return(NULL)
      #if (is.null(x$Full)) return(NULL)
      
      #Pick out player
      player <- ProCollege[ProCollege$Full == x$Full,]
      
      # load hover stats
      numbers <- switch(input$skill,
                        "Points" = c(player$CPPG,player$NPPG),
                        "Rebounds" = c(player$CRPG,player$NRPG),
                        "Assists" = c(player$CAPG,player$NAPG),
                        "Blocks" = c(player$CBPG,player$NBPG),
                        "Steals" = c(player$CSPG,player$NSPG))
      
      paste0("<b>", player$Full, "</b><br>",
             "<em>",player$POS,", ",player$School,"<br>",
             "#", player$Pick," Pick in ",player$Draft,"</em><br>",
             "College: ",numbers[1], "<br>",
             "NBA: ",numbers[2])
    }
    
    # load college statistics
    col.stats <- switch(input$skill,
                        "Points" = ProCollege$CPPG,
                        "Rebounds" = ProCollege$CRPG,
                        "Assists" = ProCollege$CAPG,
                        "Blocks" = ProCollege$CBPG,
                        "Steals" = ProCollege$CSPG)
    
    # load NBA statistics
    pro.stats <- switch(input$skill,
                        "Points" = ProCollege$NPPG,
                        "Rebounds" = ProCollege$NRPG,
                        "Assists" = ProCollege$NAPG,
                        "Blocks" = ProCollege$NBPG,
                        "Steals" = ProCollege$NSPG)
    
    # plot the college vs. NBA data
    ProCollege %>% 
      ggvis(~col.stats, ~pro.stats) %>%
      layer_points(size := 50, size.hover := 200,
                   fillOpacity := 0.6, fillOpacity.hover := 1,
                   key := ~Full) %>%
      add_tooltip(player_tooltip, "hover") %>%
      add_axis("x", title = paste("College",input$skill,"Per Game")) %>%
      add_axis("y", title = paste("Peak NBA",input$skill,"Per Game"))
  })
  
  vis %>% bind_shiny("plot")
  

  output$table <- renderDataTable({
    # Subset the data frame by draft years selected
    ProCollege <- filter(CollegePro, Draft >= input$years[1], Draft <= input$years[2])
    
    # Subset the data frame by position
    ProCollege <- filter(ProCollege, POS %in% input$position)
    
    # Subset the data frame by pick number
    ProCollege <- filter(ProCollege, Pick >= input$pick[1], Pick <= input$pick[2])
    
    # Sort by Win Shares
    ProCollege <- arrange(ProCollege, desc(WS))
    
    # make table
    ProCollege <- ProCollege[,c("Draft","Pick","POS","Full","WS")]
    
  },
  options = list(pageLength = 10))
  
  # end session
  session$onSessionEnded(function() {
    stopApp()
    q("no")
  })
  
})
