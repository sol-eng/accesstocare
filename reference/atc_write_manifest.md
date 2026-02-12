# Prepares manifest file

A convinience function that simplifies the creation of the manifest file
needed for publication.

## Usage

``` r
atc_write_manifest(
  folder_location,
  primary_document = NULL,
  ignore_files = list("config.yml", ".gitignore", "manifest.json", ".DS_Store",
    ".gitignore"),
  silent = FALSE
)
```

## Arguments

- folder_location:

  The folder containing the files of a single asset to be published

- primary_document:

  An optional argument. If passed, the function will use that as the
  name of the primary document

- ignore_files:

  A list of files to be disregarded when creating the manifest file.

- silent:

  To run with or without console updates
