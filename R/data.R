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

