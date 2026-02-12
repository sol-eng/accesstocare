# List of US Counties

It contains the number of hospitals, population and the prediction
results. It also contains the county's 'FIPS' number which is used as
the primary identifier.

## Usage

``` r
us_counties
```

## Format

A tibble with 9 variables and 3,142 rows:

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
