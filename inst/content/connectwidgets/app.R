library(shiny)
library(connectwidgets)
#library(shinydashboard)
library(shinymaterial)
library(dplyr)
library(stringr)
library(fs)
library(readr)
library(accesstocare)


if(Sys.getenv("R_CONFIG_ACTIVE") == "rsconnect") {
  connect_server <- Sys.getenv("CONNECT_SERVER")
  connect_key <- Sys.getenv("CONNECT_API_KEY")
  client <- connect(server  = connect_server, api_key = connect_key)
  all_content <- content(client)   
} else {
  if(!file_exists("content.rds")) {
    connect_server <- Sys.getenv("CONNECT_SERVER")
    connect_key <- Sys.getenv("CONNECT_API_KEY")
    client <- connect(server  = connect_server, api_key = connect_key)
    all_content <- content(client) 
    write_rds(all_content, "content.rds")
  } else {
    all_content <- read_rds("content.rds")
  }
}

choice_types <- c("All", "Script", "Report", "Dashboard", "Data", "Model", 
                  "Notebook", "Plot"
                  )

atc_content <- all_content %>% 
  by_tags("Access to Care") %>% 
  mutate(
    title = str_remove(title, "Access to Care - "), 
    type = case_when(
      content_category == "pin" ~ "Data",
      TRUE ~ "Script"
    )
    ) 


ui <- material_page(
  title = "Access to Care",
  primary_theme_color = palette_atc$ok,
  secondary_theme_color = palette_atc$below,
  material_side_nav(
    fixed = TRUE, 
    material_radio_button(
      input_id = "type",
      label = "Content Type",
      choices = choice_types
    ),

  ),
  material_parallax("hospital.jpeg"),
  material_row(
    rscgridOutput("grid")
  )
)
  
server <- function(input, output, session) {
  
  output$grid <- renderRscgrid({
    if(input$type != "All") {
      fa <- atc_content %>% 
        filter(type == input$type)
    } else {
      fa <- atc_content
    }
    rsc_grid(fa)
  })

}
shinyApp(ui = ui, server = server)