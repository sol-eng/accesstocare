- [Introduction](#introduction)
- [Analysis Background](#analysis-background)
- [Quick Start: Deploy to Posit
  Connect](#quick-start-deploy-to-posit-connect)
  - [Programmatic deployment](#programmatic-deployment)
  - [Manual deployment](#manual-deployment)
  - [Customizing content](#customizing-content)
- [Available Content](#available-content)

## Introduction

An R package to make it easy to view, copy, interact and publish the
data products resulting from the Access to Care analysis. It also
contains handy utility functions, and the data needed to create a
consistent set of examples across the multiple data product types.

## Analysis Background

This project combines US Census population data with hospital data
provided by Medicare. The Census data is as of 2024, and the hospital
Medicare data is as of 2025. The analysis uses individual counties as
the unit of measurement. A county is considered underserved based on a
linear model that compares the number of hospitals to the population.

## Quick Start: Deploy to Posit Connect

The fastest way to get started is to deploy the pre-built content
collection directly to your Posit Connect instance.

### Programmatic deployment

1.  Clone the
    [sol-eng/access-to-care](https://github.com/sol-eng/access-to-care)
    repository:

``` bash
git clone https://github.com/sol-eng/access-to-care.git
cd access-to-care
```

2.  Install the `accesstocare` package:

``` r
pak::pak("sol-eng/accesstocare")
```

3.  Deploy all content to Posit Connect:

``` r
library(accesstocare)
deploy_git_backed(".")
```

This will automatically deploy all example data products to your Posit
Connect instance using Git-backed deployment. The function will:

- Set custom
  [thumbnails](https://docs.posit.co/connect/user/content-settings/#content-image)
  for each content item
- Configure [vanity
  URLs](https://docs.posit.co/connect/user/content-settings/#vanity-url)
  for easy access

### Manual deployment

If you prefer not to deploy programmatically, you can deploy the content
manually through the Posit Connect interface:

1.  Clone the
    [sol-eng/access-to-care](https://github.com/sol-eng/access-to-care)
    repository
2.  Follow the instructions for [linking Git to Posit
    Connect](https://docs.posit.co/connect/user/git-backed/#linking-git-to-posit-connect)
    to deploy the content

### Customizing content

If you want to customize the example content:

1.  Fork the
    [sol-eng/access-to-care](https://github.com/sol-eng/access-to-care)
    repository
2.  Clone your fork locally
3.  Install the package:

``` r
pak::pak("sol-eng/accesstocare")
library(accesstocare)
```

4.  Generate fresh content:

``` r
create_content()
```

5.  Make your edits to the content folders

6.  Deploy to Posit Connect:

``` r
deploy_git_backed(".")
```

This will update any needed manifests and deploy your customized content

## Available Content

The package includes 14 example data products demonstrating different
ways to visualize and present the Access to Care analysis across
multiple frameworks and languages:

- `"api-python"` - REST API using FastAPI and Python
- `"api-r"` - REST API using Plumber and R
- `"app-python"` - Python Dash application
- `"app-r"` - Shiny application
- `"connectwidgets"` - Overview application listing all related content
- `"dashboard-python"` - Quarto dashboard with Python, Polars, and
  Plotnine
- `"dashboard-r"` - Quarto dashboard with R
- `"htmlwidgets-r"` - Interactive county-level plot
- `"pdf-r"` - PDF report
- `"pins-data"` - Data file for pins deployment
- `"plot-r"` - Static ggplot2 map of entire country
- `"presentation-python"` - Quarto presentation (Python)
- `"presentation-r"` - Quarto presentation (R)
- `"report-python"` - Quarto HTML document with Python, Polars,
  Plotnine, and Great Tables
- `"report-r"` - R Markdown HTML report with email template

If you wish to create individual content locally, you can use these
values with
[`create_content()`](https://sol-eng.github.io/accesstocare/reference/create_content.md):

``` r
# Create a specific content type
create_content(content = "app-r")

# Or create all content
create_content(content = "all")
```
