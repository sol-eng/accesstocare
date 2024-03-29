% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{us_large_cities}
\alias{us_large_cities}
\title{List of large cities}
\format{
A tibble with 7 variables and 1,005 rows:
\describe{
\item{state_name}{Name of the state}
\item{state}{Two letter state abbreviation}
\item{population}{Population count estimate for 2015}
\item{capital}{2 for capital of the state, 0 for not}
\item{x}{Map location used a converted number from the citie's longitude}
\item{y}{Map location used a converted number from the citie's latitude}
\item{position}{Rank within the state based on the population number}
}
}
\usage{
us_large_cities
}
\description{
List of the largest cities in a given state.
}
\keyword{datasets}
