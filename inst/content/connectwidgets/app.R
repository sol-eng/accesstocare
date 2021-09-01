library(shiny)
library(connectwidgets)
library(dplyr)
library(stringr)

connect_server <- Sys.getenv("CONNECT_SERVER")
connect_key <- Sys.getenv("CONNECT_API_KEY")

client <- connect(server  = connect_server, api_key = connect_key)

all_content <- content(client) 

atc_content <- all_content %>% 
  by_tags("Access to Care") %>% 
  mutate(title = str_remove(title, "Access to Care - ")) 

ui <- fillPage(
  fillCol(
    absolutePanel(top = 199, left = 30, rscgridOutput("pins")),
    absolutePanel(top = 200, left = 30, rsccardOutput("prep"))
    )
  )


server <- function(input, output, session) {
  output$content <- renderRsccard(rsc_card(atc_content[1, ]))
  
  output$pins <- renderRscgrid(rsc_grid(
    atc_content %>% 
      filter(content_category == "pin")
    ))
  output$prep <- renderRsccard(rsc_card(
    atc_content %>% 
      filter(str_detect(name, "Prep"))
  ))
}
shinyApp(ui = ui, server = server)