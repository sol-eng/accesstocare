library(shiny)
library(connectwidgets)
library(shinymaterial)
library(dplyr)
library(stringr)
library(fs)
library(readr)
library(accesstocare)


if (Sys.getenv("R_CONFIG_ACTIVE") == "rsconnect") {
  connect_server <- Sys.getenv("CONNECT_SERVER")
  connect_key <- Sys.getenv("CONNECT_API_KEY")
  client <- connect(server = connect_server, api_key = connect_key)
  all_content <- content(client)
} else {
  if (!file_exists("content.rds")) {
    connect_server <- Sys.getenv("CONNECT_SERVER")
    connect_key <- Sys.getenv("CONNECT_API_KEY")
    client <- connect(server = connect_server, api_key = connect_key)
    all_content <- content(client)
    write_rds(all_content, "content.rds")
  } else {
    all_content <- read_rds("content.rds")
  }
}

choice_types <- c(
  "All", "Script", "Report", "Dashboard", "Data", "Model",
  "Notebook", "Plot"
)

atc_content <- all_content %>%
  by_tags("Access to Care") %>%
  mutate(
    title = str_remove(title, "Access to Care - "),
    type = case_when(
      content_category == "pin" ~ "Data",
      TRUE ~ "Script"
    ),
    language = case_when(
      str_detect(app_mode, "python") ~ "python",
      TRUE ~ "R"
    )
  )


ui <- material_page(
  title = "Access to Care",
  primary_theme_color = palette_atc$ok,
  secondary_theme_color = palette_atc$above,
  background_color = "white",
  material_parallax("hospital1.png"),
  fluidRow(
    absolutePanel(
      material_radio_button(
        "type",
        label = "Content Type",
        choices = choice_types
      ),
      right = 20,
      top = 70
    )
  ),
  fluidRow(
    absolutePanel(
      material_radio_button(
        input_id = "language",
        label = "Language",
        choices = c("All", "R", "python")
      ),
      right = 200,
      top = 70
    )
  ),
  fluidRow(
    absolutePanel(
      rsccardOutput("grid", width = "90%"),
      left = 200,
      width = "80%"
    )
  )
)

server <- function(input, output, session) {
  output$grid <- renderRsccard({
    fa <- atc_content
    
    if (input$type != "All") fa <- filter(fa, type == input$type)
    
    if (input$language != "All") fa <- filter(fa, language == input$language)
    
    if (nrow(fa) > 0) {
      rsc_card(fa)
    } else {
      NULL
    }
  })
  
  
}
shinyApp(ui = ui, server = server)
