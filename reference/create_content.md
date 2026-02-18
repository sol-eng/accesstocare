# Create Access To Care example content

Copies example content from the package to a target directory.

## Usage

``` r
create_content(
  target = ".",
  content = c("all", "api-python", "api-r", "app-python", "app-r", "connectwidgets",
    "dashboard-python", "dashboard-r", "htmlwidgets-r", "pdf-r", "pins-data", "plot-r",
    "presentation-python", "presentation-r", "report-python", "report-r"),
  force = FALSE,
  silent = FALSE,
  manifest = TRUE
)
```

## Arguments

- target:

  The destination directory where content will be copied. Defaults to
  current directory.

- content:

  Which content to copy. Can be "all" to copy everything, or a specific
  content name. Available options include: "all", "api-python", "api-r",
  "app-python", "app-r", "connectwidgets", "dashboard-python",
  "dashboard-r", "htmlwidgets-r", "pdf-r", "pins-data", "plot-r",
  "presentation-python", "presentation-r", "report-python", "report-r".

- force:

  If TRUE, overwrites existing folders. If FALSE (default), skips
  existing folders.

- silent:

  If TRUE, suppresses console messages. Defaults to FALSE.

- manifest:

  If TRUE (default), automatically creates a manifest.json file for each
  content folder (except pins content). Set to FALSE to skip manifest
  creation.
