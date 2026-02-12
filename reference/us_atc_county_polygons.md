# Coordinates to draw counties

Coordinates to draw counties

## Usage

``` r
us_atc_county_polygons
```

## Format

A tibble with 19 variables and 54,187 rows:

- fips:

  County FIPS

- state:

  Two letter state abbriviation

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
  bellow = Bellow lower end

- state_name:

  Name of the state

- x:

  Map location used a converted number from longitude

- y:

  Map location used a converted number from latitude

- order:

  The order or the position

- hole:

  Is a hole
