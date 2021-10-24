library(shiny)
library(shinyWidgets)
library(shiny.semantic)
library(htmltools)
library(leaflet)

library(dplyr)
library(magrittr)
library(geosphere)

# import the dataset (rds format for a fast reading).
ships = readRDS("ships.rds")

testthat::expect_is(ships, "data.frame")

#### Grid template ####

myGridTemplate <- grid_template(
  
  default = list(
    areas = rbind(c("title", "map"), c("user", "map")),
    cols_width = c("300px", "1fr"),
    rows_height = c("60px", "auto", "150px")
  ),
  
  mobile = list(
    areas = rbind("title", "user", "map"),
    rows_height = c("70px", "400px", "auto"),
    cols_width = c("100%")
  )
  
)

#### UI ####
ui <- 
  semanticPage(
    setBackgroundColor("#f0ebe1"),
    tags$style(type = "text/css", "#Map {height: calc(110vh - 100px) !important;}"),
    
    grid(grid_template = myGridTemplate,
         area_styles = list(title = "margin: 20px;", map = "margin: 0px;", user = "margin: 20px;"),
         
         title = h2(class = "ui header", icon("anchor"), div(class = "content", "Ship dashboard")),
         
         map = leafletOutput(outputId = "Map", width = "100%", height = "200%"),
         
         user = div(
           
           card(
             style = "border-radius: 0; width: 100%",
             div(class = "content",
             p("Vessel type"),
             dropdown_input("vessel_type", choices = sort(unique(ships$ship_type)), value = 0), br(),
             p("Vessel name"),
             dropdown_input("vessel_name", choices = unique(ships[ships$ship_type == 7,]$SHIPNAME), value = "VTS HEL")
             )),
           
           card(
             style = "border-radius: 0; width: 100%",
             div(class = "content", 
                 div(class = "header", "Ship's max sailed distance"), 
                 div(class = "meta", "Distance in meters"),
                 div(class = "description", h2(textOutput("Distance")))))
           )
      )
    )



#### Server ####
server <- function(input, output, session) { 
  
  observe({
    x <- input$vessel_type
    
    # Can use character(0) to remove all choices
    if (is.null(x))
      x <- character(0)
    
    # Can also set the label and select items
    updateSelectInput(session, "vessel_name",
                      label = paste("Select vessel name", x),
                      choices = sort(unique(ships[ships$ship_type == x,]$SHIPNAME)),
                      selected = tail(x, 1)
    )
  })
   
  #'[DATA]
  df = reactive({
    # 3 
    # For the vessel selected, find the observation when it sailed the longest distance between two consecutive observations.
    # If there is a situation when a vessel moves exactly the same amount of meters, please select the most recent.
    
    df2 = 
      ships[ships$SHIPNAME == input$vessel_name,] %>%
      arrange(desc(DATETIME)) %>% # select the most recent observation, if there is same sailed distance.
      mutate(dist = distHaversine(cbind(LON, LAT), cbind(lead(LON), lead(LAT)))) # calculate the Haversine distance between two consecutive locations.
    
    # df2 %>% slice(which.max(dist))
    df = df2[which.max(df2$dist):(which.max(df2$dist)+1),]
  })
  
  output$Distance = renderText({paste(round(df()$dist[1], 0), "m")})
  
  #'[MAP]
  map = reactive({
    
    df = df()
    
    # Initialize the map
    map = leaflet() %>% addTiles()
    
    # Label's HTML style
    style = "<div style=\'font-family:Trebuchet MS, sans-serif; color: #003366; font-size:15\'>
    <span style='color:#7d7d7d'>&#9972 Ship's Name</span>
    <br/>%s<br/>
    <span style='color:#7d7d7d'>Date & Time</span>
    <br/>%s
    </i></div>"
    
    map %>% 
      # Start marker
      addCircleMarkers(data = df[1,], lng = df[1,]$LON, lat = df[1,]$LAT,
                       fillColor = "#de5272",
                       fillOpacity = 0.9, 
                       stroke = TRUE, 
                       color = "gray", 
                       weight = 1,
                       label = ~sprintf(style, df[1,]$SHIPNAME, df[1,]$DATETIME) %>% lapply(htmltools::HTML)) %>%
      # End marker
      addCircleMarkers(data = df[2,], lng = df[2,]$LON, lat = df[2,]$LAT,
                       fillColor = "#00b2a9",
                       fillOpacity = 0.9, 
                       stroke = TRUE, 
                       color = "gray", 
                       weight = 1,
                       label = ~sprintf(style, df[2,]$SHIPNAME, df[2,]$DATETIME) %>% lapply(htmltools::HTML)) %>%
      
      addLegend("bottomright", colors = c("#00b2a9", "#de5272"), labels = c("Start", "End"), opacity = 1)
    
    }) # end Map
  
  output$Map = renderLeaflet({map()})
  
}

shinyApp(ui = ui, server = server)
