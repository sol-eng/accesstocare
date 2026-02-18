# Coordinates to draw counties

Contains county polygon coordinates in both projected (x/y for ggplot)
and geographic (long/lat for leaflet) coordinate systems.

## Usage

``` r
us_atc_county_polygons
```

## Format

A tibble with 18 variables and 54,187 rows:

- fips:

  County FIPS

- state:

  Two letter state abbreviation

- county_name:

  Name of the county

- hospitals:

  Number of hospitals inside the county

- population:

  Population count estimate for 2015

- pred_fit:

  Fit result from model

- pred_lwr:

  Lower end of prediction from model

- pred_upr:

  Top end of prediction from model

- pred_status:

  ok = If above lower end, and below upper end, above = Above upper end,
  below = Below lower end

- state_name:

  Name of the state

- x:

  Map location in projected coordinates (for ggplot)

- y:

  Map location in projected coordinates (for ggplot)

- long:

  Longitude in decimal degrees (for leaflet)

- lat:

  Latitude in decimal degrees (for leaflet)

- hole:

  Is a hole

- piece:

  Polygon piece number

- group:

  Grouping variable for polygons

- order:

  Row number within each group for proper coordinate matching
