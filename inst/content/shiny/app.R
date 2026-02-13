library(accesstocare)
library(leaflet)
library(dplyr)
library(gt)
library(sf)

state_choices <- c("Model", "No. of Hospitals", "Population")

ui <- fillPage(
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(
    top = 10,
    right = 10,
    width = 300,
    height = "auto",
    div(
      style = "background: white; padding: 15px; border-radius: 5px; box-shadow: 0 0 15px rgba(0,0,0,0.2);",
      radioButtons(
        inputId = "view",
        label = "Select a view:",
        choices = state_choices
      )
    ),
    draggable = TRUE
  )
)

server <- function(input, output, session) {

  # Use precomputed county boundaries from package
  county_sf <- reactive({
    us_counties_longlat
  })

  output$map <- renderLeaflet({
    # Base map
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      setView(lng = -98.5, lat = 39.5, zoom = 4)
  })

  observe({
    req(county_sf())

    counties_data <- county_sf()

    # Determine variable and colors
    if(input$view == "Population") {
      fill_var <- counties_data$population
      pal <- colorNumeric("YlOrRd", domain = fill_var, na.color = "#808080")
      legend_title <- "Population"
    } else if(input$view == "No. of Hospitals") {
      fill_var <- counties_data$hospitals
      pal <- colorNumeric("YlGnBu", domain = fill_var, na.color = "#808080")
      legend_title <- "Hospitals"
    } else {
      # Model view
      fill_var <- counties_data$pred_status
      pal <- colorFactor(
        palette = c("above" = "#0072B2", "below" = "#CC79A7", "ok" = "#009E73"),
        domain = c("above", "below", "ok"),
        na.color = "#808080"
      )
      legend_title <- "Model Status"
    }

    # Create labels
    labels <- sprintf(
      "<strong>%s, %s</strong><br/>Population: %s<br/>Hospitals: %s",
      counties_data$county_name, counties_data$state,
      format(counties_data$population, big.mark = ","),
      counties_data$hospitals
    ) %>% lapply(htmltools::HTML)

    # Update map
    leafletProxy("map", data = counties_data) %>%
      clearShapes() %>%
      clearControls() %>%
      addPolygons(
        fillColor = ~pal(fill_var),
        weight = 1,
        opacity = 1,
        color = "white",
        fillOpacity = 0.7,
        highlightOptions = highlightOptions(
          weight = 2,
          color = "#666",
          fillOpacity = 0.9,
          bringToFront = TRUE
        ),
        label = labels,
        layerId = ~fips
      ) %>%
      addLegend(
        position = "bottomright",
        pal = pal,
        values = fill_var,
        title = legend_title,
        opacity = 0.7
      )
  })

  observeEvent(input$map_shape_click, {
    click <- input$map_shape_click

    if(!is.null(click$id)) {
      sel_county <- us_hospitals %>%
        filter(fips == click$id)

      if(nrow(sel_county) > 0) {
        showModal(modalDialog(
          title = paste0(sel_county$county_name[1], ", ", sel_county$state[1]),
          sel_county %>%
            arrange(city, facility_name) %>%
            mutate(nbr = row_number()) %>%
            select(nbr, facility_name, city) %>%
            gt() %>%
            cols_label(
              nbr = "",
              facility_name = "Hospital Name",
              city = "City"
            ) %>%
            tab_options(table.font.size = 8),
          easyClose = TRUE,
          fade = TRUE
        ))
      }
    }
  })
}

shinyApp(ui, server)