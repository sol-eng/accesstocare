
<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/sol-eng/accesstocare/branch/main/graph/badge.svg)](https://codecov.io/gh/sol-eng/accesstocare?branch=main)
[![R-CMD-check](https://github.com/sol-eng/accesstocare/workflows/R-CMD-check/badge.svg)](https://github.com/sol-eng/accesstocare/actions)
<!-- badges: end -->

-   [Access to Care](#access-to-care)
-   [Analysis Background](#analysis-background)
-   [Installation](#installation)
-   [Usage](#usage)
    -   [Run an example](#run-an-example)
    -   [Copy example](#copy-example)
    -   [Copy all examples](#copy-all-examples)

## Access to Care

An R package to make it easy to view, copy, interact and publish the
data products resulting from the Access to Care analysis. It also
contains handly utlity functions, and the data needed to create a
consistent set of examples across the multiple data product types.

## Analysis Background

This project combines US CENSUS population data with hospital data
provided by Medicare. A linear model is used to determine if a county is
over, or under served based on the size of the population.

## Installation

Install `accesstocare` from GitHub using:

``` r
devtools::install_github("sol-eng/accesstocare")
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
#> 1    connectwidgets            Report 
#> 2    dash                      Dashboard 
#> 3    flexdashboard             Dashboard 
#> 4    htmlwidgets               Plot 
#> 5    jupyter                   Jupyter 
#> 6    launcher-programatic      Launcher 
#> 7    plot                      Plot 
#> 8    plumber-api               REST API 
#> 9    powerpoint                PowerPoint 
#> 10   powerpoint-state          PowerPoint 
#> 11   presentation              Presentation 
#> 12   RMarkdown-DataPrep        Scheduled R Script 
#> 13   RMarkdown-html            Report 
#> 14   RMarkdown-pdf             Report 
#> 15   RNotebook                 Notebook 
#> 16   shiny                     Dashboard
```

There are three ways to use the examples:

-   Open an example in your RStudio session - `atc_open_content()`
-   Copy a single example to disk - `atc_copy_content()`
-   Copy all examples to disk - `atc_copy_all_content()`

### Run an example

``` r
atc_open_content()
```

    #> No.  Name                      Type 
    #> 1    connectwidgets            Report 
    #> 2    dash                      Dashboard 
    #> 3    flexdashboard             Dashboard 
    #> 4    htmlwidgets               Plot 
    #> 5    jupyter                   Jupyter 
    #> 6    launcher-programatic      Launcher 
    #> 7    plot                      Plot 
    #> 8    plumber-api               REST API 
    #> 9    powerpoint                PowerPoint 
    #> 10   powerpoint-state          PowerPoint 
    #> 11   presentation              Presentation 
    #> 12   RMarkdown-DataPrep        Scheduled R Script 
    #> 13   RMarkdown-html            Report 
    #> 14   RMarkdown-pdf             Report 
    #> 15   RNotebook                 Notebook 
    #> 16   shiny                     Dashboard
    #> 17   Cancel
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
    #> 1    connectwidgets            Report 
    #> 2    dash                      Dashboard 
    #> 3    flexdashboard             Dashboard 
    #> 4    htmlwidgets               Plot 
    #> 5    jupyter                   Jupyter 
    #> 6    launcher-programatic      Launcher 
    #> 7    plot                      Plot 
    #> 8    plumber-api               REST API 
    #> 9    powerpoint                PowerPoint 
    #> 10   powerpoint-state          PowerPoint 
    #> 11   presentation              Presentation 
    #> 12   RMarkdown-DataPrep        Scheduled R Script 
    #> 13   RMarkdown-html            Report 
    #> 14   RMarkdown-pdf             Report 
    #> 15   RNotebook                 Notebook 
    #> 16   shiny                     Dashboard
    #> 17   Cancel
    #> Enter the content number:

To avoid the interactive menu, pass the number to the left of the
example, as an argument of the function:

``` r
atc_copy_content(3)  # Copies the `flexdashboard` folder
```

### Copy all examples

`atc_copy_all_content()` will copy all of the examples. It will as many
sub-folders as there are examples available.
