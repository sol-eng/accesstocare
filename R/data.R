#' List of US Counties
#' @description It contains the number of hospitals, population and the prediction
#' results.  It also contains the county's 'FIPS' number which is used as the
#' primary identifier.
#' @format A tibble with 9 variables and 3,142 rows:
#' \describe{
#' \item{fips}{County FIPS}
#' \item{state}{Two letter state abbriviation}
#' \item{county_name}{Name of the county}
#' \item{hospitals}{Number of hospitals inside the county}
#' \item{population}{Population count estimate for 2015}
#' \item{pred_fit}{Fit result from model}
#' \item{pred_lwr}{Lower end of prediction from model}
#' \item{pred_upr}{Top end of prediction from model}
#' \item{pred_status}{ok = If above lower end, and below upper end, above = Above upper end, bellow = Bellow lower end}
#' }
"us_counties"

#' List of hospitals in the USA
#' @format A tibble with 9 variables and 4,669 rows:
#' \describe{
#' \item{facility_id}{Hospital's ID as per Medicare}
#' \item{facility_name}{Hospital's name}
#' \item{address}{Hospital's address}
#' \item{city}{Hospital's city}
#' \item{zip_code}{Hospital's Zip Code}
#' \item{fips}{County FIPS}
#' \item{state}{Hospital's two letter state abbreviation}
#' \item{county_name}{Name of the county}
#' \item{state_name}{Name of the state}
#' }
"us_hospitals"

#' List of states in the USA
#' @description A list of the 50 states, and District of Columbia.  It contains
#' the number of hospitals and population per state.
#' @format A tibble with 6 variables and 51 rows:
#' \describe{
#' \item{state}{Two letter state abbreviation}
#' \item{hospitals}{Number of hospitals inside the county}
#' \item{population}{Population count estimate for 2015}
#' \item{per_person}{Population divided by the number of hospitals in the state}
#' \item{per_person_quartile}{Quartile for per_person variable}
#' \item{state_name}{Name of the state}
#' }
"us_states"

#' List of large cities
#' @description List of the largest cities in a given state.
#' @format A tibble with 7 variables and 1,005 rows:
#' \describe{
#' \item{state_name}{Name of the state}
#' \item{state}{Two letter state abbreviation}
#' \item{population}{Population count estimate for 2015}
#' \item{capital}{2 for capital of the state, 0 for not}
#' \item{x}{Map location used a converted number from the citie's longitude}
#' \item{y}{Map location used a converted number from the citie's latitude}
#' \item{position}{Rank within the state based on the population number}
#' }
"us_large_cities"

#' Coordinates to center each state's hexagon
#' @description A manually created list of 'x' and 'y' coordinates to place the
#' hexagons representing each state in the USA. These are relative positions from
#' each of the other states.
#' @format A tibble with 4 variables and 51 rows:
#' \describe{
#' \item{state}{Two letter state abbreviation}
#' \item{x}{Sets the 'x' position}
#' \item{x}{Sets the 'y' position}
#' \item{state_name}{Name of the state}
#' }
"us_hex_positions"

#' Position of the 6 corners for each state's hexagon
#' @format A tibble with 3 variables and 306 rows:
#' \describe{
#' \item{x}{Sets the 'x' position}
#' \item{x}{Sets the 'y' position}
#' \item{state}{Two letter state abbreviation}
#' }
"us_hex_polygons"

#' Linear regression model that compares hospitals and population in a given
#' US county
#' @format An linear regression model object
"us_atc_model"

#' A list of color defaults
#' @description It has a list of the default hex color value for the different
#' plots used in the examples.
#' @format A list with 6 elements
"palette_atc"

#' Coordinates to draw state's hexagons
#' @description It joins the us_states and us_hex_polygons data sets
#' @format A tibble with 11 variables and 306 rows:
#' \describe{
#' \item{state}{Two letter state abbreviation}
#' \item{hospitals}{Number of hospitals inside the county}
#' \item{population}{Population count estimate for 2015}
#' \item{per_person}{Population divided by the number of hospitals in the state}
#' \item{per_person_quartile}{Quartile for per_person variable}
#' \item{state_name}{Name of the state}
#' \item{x}{Sets the 'x' position}
#' \item{x}{Sets the 'y' position}
#' }
"us_atc_state_polygons"

#' Coordinates to draw counties
#' @format A tibble with 19 variables and 54,187 rows:
#' \describe{
#' \item{fips}{County FIPS}
#' \item{state}{Two letter state abbriviation}
#' \item{county_name}{Name of the county}
#' \item{hospitals}{Number of hospitals inside the county}
#' \item{population}{Population count estimate for 2015}
#' \item{pred_fit}{Fit result from model}
#' \item{pred_lwr}{Lower end of prediction from model}
#' \item{pred_upr}{Top end of prediction from model}
#' \item{pred_status}{ok = If above lower end, and below upper end, above = Above upper end, bellow = Bellow lower end}
#' \item{state_name}{Name of the state}
#' \item{x}{Map location used a converted number from longitude}
#' \item{y}{Map location used a converted number from latitude}
#' \item{order}{The order or the position}
#' \item{hole}{Is a hole}
#' }
"us_atc_county_polygons"


#' Medicare list of hospitals
#' @description A list of hospitals in the USA provided by Medicare.
#' @format A tibble with 9 variables and 5,336 rows:
#' \describe{
#' \item{facility_id}{Hospital's ID as per Medicare}
#' \item{facility_name}{Hospital's name}
#' \item{address}{Hospital's address}
#' \item{city}{Hospital's city}
#' \item{state}{Hospital's two letter state abbreviation}
#' \item{zip_code}{Hospital's Zip Code}
#' \item{county_name}{Name of the county}
#' \item{phone_number}{Hospital's phone number}
#' \item{hospital_type}{Type of care the hospital provides}
#' }
"cms_raw_data"
