# Prepare Git-backed deployment manifests

Intelligently creates manifest files for Posit Connect Git-backed
deployment. If the folder contains a primary document, creates a
manifest for that folder. If not, checks subfolders (one level deep) and
creates manifests for each subfolder with a primary document.

## Usage

``` r
create_git_backed(
  folder_location = ".",
  primary_document = NULL,
  ignore_files = list("config.yml", ".gitignore", "manifest.json", ".DS_Store"),
  silent = FALSE
)
```

## Arguments

- folder_location:

  The folder containing content to prepare for deployment

- primary_document:

  An optional argument. If passed, the function will use that as the
  name of the primary document

- ignore_files:

  A list of files to be disregarded when creating the manifest file.

- silent:

  To run with or without console updates
