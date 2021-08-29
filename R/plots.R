#' Plot of all counties hospital and population 
#' 
#' @description Returns a scatter plot comparing Hospital vs Population counts 
#' in a given county
#' 
#' @param population_max Top end limit for population count to display in the
#' plot. Defaults to 11 million. 
#' @param model_colors A list of 3 colors to use for counties below, above or
#' at the level of expected hospitals as per the model.
#' @param show_model_results To highlight which counties are above or below the
#' expected number of hospitals
#' @export
atc_plot_hospitals <- function(population_max = 11000000,
                               model_colors = list(above = palette_atc$above, 
                                                   below = palette_atc$below, 
                                                   ok = palette_atc$ok
                                                   ),
                               show_model_results = FALSE
                               ) {
  
  font <- "Helvetica"
  
  prep_counties <- us_counties[us_counties$population <= population_max, ]
  
  prep_counties$tooltip <- paste0(
    prep_counties$county_name, ", ", prep_counties$state,
    "\nPopulation: ", format_number(prep_counties$population), 
    "\nHospitals: ", format_number(prep_counties$hospitals)
  )
  
  p_seg <- (max(prep_counties$population) - min(prep_counties$population)) / 4
  
  p_breaks <- c(0, p_seg * 1:4)
  p_labels <- format_number(p_breaks)
  
  gp <- ggplot(data = prep_counties) +
    geom_point_interactive(
      aes(hospitals, population, data_id = fips, tooltip = tooltip), 
      color = "#cc9900"
    ) +
    scale_y_continuous(breaks = p_breaks, labels = p_labels) +
    labs(x = "Hospitals", y = "Population") +
    theme_minimal() +
    theme(
      axis.text = element_text(font), 
      text = element_text(font)
      )
  
  if(show_model_results) {
    
    h_count <- c(100000, population_max)
    
    h_pred <- predict(
      us_atc_model, 
      newdata = data.frame(population = h_count),
      interval = "prediction"
    )
    
    h_pred <- as.data.frame(h_pred)
    h_pred$population <- h_count  
    
    lwr_tbl <- data.frame(
      x = c(h_pred$lwr, h_pred$lwr[1]),
      y = c(h_pred$population, h_pred$population[2])
    ) 
    
    upr_tbl <- data.frame(
      x = c(h_pred$upr, h_pred$upr[2]),
      y = c(h_pred$population, h_pred$population[1])
    ) 
    
    gp <- gp +
      geom_polygon(
        aes(x, y), data = lwr_tbl, alpha = 0.4, fill = model_colors$below
        ) +
      geom_polygon(
        aes(x, y), data = upr_tbl, alpha = 0.4, fill = model_colors$above
        ) 
  }
  gp
}

#' Hex plot of the USA
#' @description Creates a hex plot of all the states.  It positions them in a 
#' relatively close location where they would be in a map.  All of the states
#' have the same size Hex, this makes them easy to find and compare to others. 
#' 
#' @param variable The variable to use as the driver for the color or level of
#' transparency that will be displayed.  There are four options: population of
#' the state, the number of hospitals in that state, highlight states with
#' counties with counties above or below the model's predictions.  The values
#' that can be used are: population, hospitals, abover or below.  The default
#' is population.
#' @param colors A list of two colors. One set the value of the high number
#' and the other for the low number.
#' @export
atc_plot_us_map <- function(variable = c("population", "hospitals", "above", "below"),
                            colors = list(high = palette_atc$high, low = palette_atc$low)
                            ) {
  low_color <- colors$low
  high_color <- colors$high
  x_width <- 20
  font <- "Helvetica"
  
  if(variable[[1]] == "above") {
    vr <- "pred_above"
    fill_lab <- "Counties"
    high_color <- palette_atc$above
  } 
  if(variable[[1]] == "below") {
    vr <- "pred_below"
    fill_lab <- "Counties"
    high_color <- palette_atc$below
  } 
  if(variable[[1]] == "population") {
    vr <- "population"
    fill_lab <- "Population"
  } 
  if(variable[[1]] == "hospitals") {
    vr <- "hospitals"
    fill_lab <- "Hospitals"
  } 
  prep_us <- us_atc_state_polygons
  prep_us$tooltip <- paste0(
    prep_us$state_name, 
    "\nPopulation: ", format_number(prep_us$population), 
    "\nHospitals: ", format_number(prep_us$hospitals)
    )
  prep_us$fill <- prep_us[, vr][[1]]
  
  min_fill <- min(prep_us$fill)
  max_fill <- max(prep_us$fill)
  
  ggplot(data = prep_us) +
    geom_polygon_interactive(
      aes(x, y, group = state, data_id = state_name, fill = fill), 
      color = "#cccccc"
    ) +
    geom_text_interactive(
      aes(x, y, label = state, data_id = state_name), size = 4, 
      data = us_hex_positions, family = font
    ) +
    scale_fill_gradient(
      low = low_color, 
      high = high_color,
      breaks = c(min_fill, max_fill),
      labels = c(format_number(min_fill), format_number(max_fill))
      ) +
    labs(fill = fill_lab) +
    theme_void() +
    theme(
      legend.position = "bottom", 
      legend.text = element_text(family = font),
      legend.title = element_text(family = font)
    )
  
}

#' Plot of county level data 
#' @description Returns a plot with actual shape of the state, and highlights 
#' each county with a color.  The color will depend on which variable is being
#' used to plot.  
#' @param state The state's name. Use "All US" if a map of all states is to be
#' plotted. 
#' @param variable The variable to use for the plot. Possible values are: model,
#' population or hospitals.
#' @param colors A list of two colors. One set the value of the high number
#' and the other for the low number.
#' @param model_colors A list of 3 colors to use for counties below, above or
#' at the level of expected hospitals as per the model.
#' @param top_cities Plots the most populated cities.  The default to plot the
#' 3 most populated cities.  To avoid displaying any cities, use 0.
#' @export
atc_plot_state_map <- function(state = "Florida", 
                               variable = c("model", "population", "hospitals"),
                               colors = list(high = palette_atc$high, 
                                             low = palette_atc$low
                                             ),
                               model_colors = list(above = palette_atc$above, 
                                                   below = palette_atc$below, 
                                                   ok = palette_atc$ok
                                                   ),
                               top_cities = 3
                               ) {
  
  low_color <- colors$low
  high_color <- colors$high
  x_width <- 20
  font <- "Helvetica"
  
  if(variable[[1]] == "model") {
    vr <- "pred_status"
    fill_lab <- "Model results"
  }  
  if(variable[[1]] == "population") {
    vr <- "population"
    fill_lab <- "Population"
  } 
  if(variable[[1]] == "hospitals") {
    vr <- "hospitals"
    fill_lab <- "Hospitals"
  } 
  if(state == "All US") {
    prep_us <- us_atc_county_polygons
    prep_cities <- us_large_cities
  } else {
    prep_us <- us_atc_county_polygons[us_atc_county_polygons$state_name == state, ]  
    prep_cities <- us_large_cities[us_large_cities$state == prep_us$state[[1]], ]
  }
  
  prep_cities <- prep_cities[prep_cities$position <= top_cities, ]
  
  prep_us$tooltip <- paste0(
    prep_us$county_name, 
    "\nPopulation: ", format_number(prep_us$population), 
    "\nHospitals: ", format_number(prep_us$hospitals)
  )
  prep_us$fill <- prep_us[, vr][[1]]
  
  gp <- ggplot(data = prep_us) +
    geom_text(aes(x, y, label = city_name), 
              data = prep_cities, 
              hjust = 1.1,
              family = font
              ) +
    geom_point(aes(x, y), data = prep_cities) +
    geom_polygon_interactive(
      aes(x, y, group = group, fill = fill, data_id = fips, tooltip = tooltip),
      color = "#cccccc", 
      size = 0.3,
      alpha = 0.6
    ) +
    labs(fill = fill_lab) +
    theme_void() +
    theme(
      legend.position = "bottom", 
      legend.text = element_text(family = font),
      legend.title = element_text(family = font)
      )
  
  if(is.numeric(prep_us$fill)) {
    min_fill <- min(prep_us$fill)
    max_fill <- max(prep_us$fill)
    gp +
      scale_fill_gradient(
        low = low_color, 
        high = high_color,
        breaks = c(min_fill, max_fill),
        labels = c(format_number(min_fill), format_number(max_fill))
      ) 
  } else {
    gp +
      scale_fill_manual(
        labels = c("Above", "Below", "At Level"),
        values = c(model_colors$above, model_colors$below, model_colors$ok),
        breaks = c("above", "below", "ok")
      ) 
  }
}

globalVariables(c(
  "x", "y", "city_name", "group", "fill", "fips", "tooltip", "palette_atc", 
  "hospitals", "population", "us_atc_model", "state", "state_name", 
  "us_atc_county_polygons", "us_atc_state_polygons", "us_counties", 
  "us_large_cities", "us_hex_positions"
  ))