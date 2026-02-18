# Coordinates to draw state's hexagons

It joins the us_states and us_hex_polygons data sets

## Usage

``` r
us_atc_state_polygons
```

## Format

A tibble with 11 variables and 306 rows:

- state:

  Two letter state abbreviation

- hospitals:

  Number of hospitals in the state

- population:

  Population count estimate for 2015

- per_person:

  Population divided by the number of hospitals in the state

- per_person_quartile:

  Quartile for per_person variable

- state_name:

  Name of the state

- x:

  Sets the 'x' position

- y:

  Sets the 'y' position

- pred_above:

  Number of counties above the model prediction

- pred_below:

  Number of counties below the model prediction

- pred_ok:

  Number of counties at the expected level
