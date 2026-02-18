# Deploy content to Posit Connect

Deploys content to Posit Connect using Git-backed deployment for most
content, and direct deployment for pins content. If the content location
contains a .connect file, deploys only that content. Otherwise, deploys
all subfolders that have a manifest.json file.

## Usage

``` r
deploy_content(
  repository = NULL,
  branch = "main",
  content_location = ".",
  client = NULL,
  skip_if_exists = TRUE
)
```

## Arguments

- repository:

  Git repository URL. If NULL (default), automatically detects from the
  current git remote.

- branch:

  Git branch to deploy from. Defaults to "main".

- content_location:

  Path to the folder containing content to deploy. Defaults to current
  directory.

- client:

  Posit Connect client object. If NULL (default), creates a new
  connection using connectapi::connect().

- skip_if_exists:

  Skips content folder if it already exists. Defaults to TRUE. Change to
  FALSE if you need to replace the thumbnail or update the Vanity URL.

## Details

For each content item:

- Checks for manifest.json (skips if missing for non-pins content)

- Reads metadata.yml for title and vanity URL configuration

- Creates or updates deployment on Posit Connect

- Saves the content GUID to a .connect file for future updates

- Sets thumbnail if thumbnail.png exists

- Configures vanity URL if specified in metadata.yml

The .connect file persists the content GUID between deployments,
enabling updates to existing content rather than creating duplicates.
