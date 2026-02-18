# Deploy Git-backed content to Posit Connect

Deploys content to Posit Connect using Git-backed deployment. If the
content location contains a .connect file, deploys only that content.
Otherwise, deploys all subfolders that have a manifest.json file.

## Usage

``` r
deploy_git_backed(
  repository = NULL,
  branch = "main",
  content_location = ".",
  client = NULL
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

## Details

For each content item:

- Checks for manifest.json (skips if missing)

- Reads metadata.yml for title and vanity URL configuration

- Creates or updates deployment on Posit Connect

- Saves the content GUID to a .connect file for future updates

- Sets thumbnail if thumbnail.png exists

- Configures vanity URL if specified in metadata.yml

The .connect file persists the content GUID between deployments,
enabling updates to existing content rather than creating duplicates.
