
<!-- badges: start -->

[![R-CMD-check](https://github.com/sol-eng/accesstocare/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/sol-eng/accesstocare/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/sol-eng/accesstocare/graph/badge.svg)](https://app.codecov.io/gh/sol-eng/accesstocare)
<!-- badges: end -->

- [Access to Care](#access-to-care)
- [Analysis Background](#analysis-background)
- [Installation](#installation)
- [Usage](#usage)
  - [Run an example](#run-an-example)
  - [Copy example](#copy-example)
  - [Copy all examples](#copy-all-examples)

## Access to Care

An R package to make it easy to view, copy, interact and publish the
data products resulting from the Access to Care analysis. It also
contains handy utility functions, and the data needed to create a
consistent set of examples across the multiple data product types.

## Analysis Background

This project combines US Census population data with hospital data
provided by Medicare. The Census data is as of 2024, and the hospital
Medicare date is as of 2025. The analysis uses individual counties as
the unit of measurement. A county is considered undeserved based on a
linear model.

## Installation

Install `accesstocare` from GitHub using:

``` r
pak::pak("sol-eng/accesstocare")
```

## Usage

``` r
library(accesstocare)
```

To view the available examples, use `atc_packate_content()`. It returns
a `list` object with all of the available content. It is presented in
the console, or RMarkdown, as a table.

``` r
atc_package_content()
#> No.  Name                      Type 
#> 1    connectwidgets            Application 
#> 2    dash                      Dashboard 
#> 3    htmlwidgets               Plot 
#> 4    jupyter                   Jupyter 
#> 5    plot                      Plot 
#> 6    plumber-api               REST API 
#> 7    presentation              Presentation 
#> 8    quarto-dashboard-r        Dashboard 
#> 9    RMarkdown-DataPrep        Scheduled R Script 
#> 10   RMarkdown-html            Report 
#> 11   RMarkdown-pdf             Report 
#> 12   shiny                     Application
```

There are three ways to use the examples:

- Open an example in your RStudio session - `atc_open_content()`
- Copy a single example to disk - `atc_copy_content()`
- Copy all examples to disk - `atc_copy_all_content()`

### Run an example

``` r
atc_open_content()
```

    #> No.  Name                      Type 
    #> 1    connectwidgets            Application 
    #> 2    dash                      Dashboard 
    #> 3    htmlwidgets               Plot 
    #> 4    jupyter                   Jupyter 
    #> 5    plot                      Plot 
    #> 6    plumber-api               REST API 
    #> 7    presentation              Presentation 
    #> 8    quarto-dashboard-r        Dashboard 
    #> 9    RMarkdown-DataPrep        Scheduled R Script 
    #> 10   RMarkdown-html            Report 
    #> 11   RMarkdown-pdf             Report 
    #> 12   shiny                     Application
    #> 18   Cancel
    #> Enter the content number:

Enter the number to the left of the example in order to run it. For
example, to open the `flexdashboard` example, type 3 and press enter.

To run an example without the prompt, pass the `content_no` argument
with the number. Again, to open the `flexdashboard` use:

``` r
atc_open_content(3)
```

### Copy example

An example can be copied to your working directory by using
`atc_copy_content()`. It will create a new sub-folder and load the files
for that particular example.

It has the same interactive mechanism as the open example function.

``` r
atc_copy_content()
```

    #> No.  Name                      Type 
    #> 1    connectwidgets            Application 
    #> 2    dash                      Dashboard 
    #> 3    htmlwidgets               Plot 
    #> 4    jupyter                   Jupyter 
    #> 5    plot                      Plot 
    #> 6    plumber-api               REST API 
    #> 7    presentation              Presentation 
    #> 8    quarto-dashboard-r        Dashboard 
    #> 9    RMarkdown-DataPrep        Scheduled R Script 
    #> 10   RMarkdown-html            Report 
    #> 11   RMarkdown-pdf             Report 
    #> 12   shiny                     Application
    #> 18   Cancel
    #> Enter the content number:

### Copy all examples

`atc_copy_all_content()` will copy all of the examples. It will as many
sub-folders as there are examples available.
