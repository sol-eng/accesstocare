% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{us_states}
\alias{us_states}
\title{List of states in the USA}
\format{
A tibble with 6 variables and 51 rows:
\describe{
\item{state}{Two letter state abbreviation}
\item{hospitals}{Number of hospitals inside the county}
\item{population}{Population count estimate for 2015}
\item{per_person}{Population divided by the number of hospitals in the state}
\item{per_person_quartile}{Quartile for per_person variable}
\item{state_name}{Name of the state}
}
}
\usage{
us_states
}
\description{
A list of the 50 states, and District of Columbia.  It contains
the number of hospitals and population per state.
}
\keyword{datasets}
