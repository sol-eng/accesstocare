#' Deploy Git-backed content to Posit Connect
#' @description Deploys content to Posit Connect using Git-backed deployment.
#' If the content location contains a .connect file, deploys only that content.
#' Otherwise, deploys all subfolders that have a manifest.json file.
#'
#' @param repository Git repository URL. If NULL (default), automatically detects
#' from the current git remote.
#' @param branch Git branch to deploy from. Defaults to "main".
#' @param content_location Path to the folder containing content to deploy.
#' Defaults to current directory.
#' @param client Posit Connect client object. If NULL (default), creates a new
#' connection using connectapi::connect().
#'
#' @details
#' For each content item:
#' - Checks for manifest.json (skips if missing)
#' - Reads metadata.yml for title and vanity URL configuration
#' - Creates or updates deployment on Posit Connect
#' - Saves the content GUID to a .connect file for future updates
#' - Sets thumbnail if thumbnail.png exists
#' - Configures vanity URL if specified in metadata.yml
#'
#' The .connect file persists the content GUID between deployments, enabling
#' updates to existing content rather than creating duplicates.
#'
#' @export
deploy_git_backed <- function(
  repository = NULL,
  branch = "main",
  content_location = ".",
  client = NULL
) {
  if (is.null(client)) {
    cli_alert_info("Connecting to Posit Connect...")
    client <- connectapi::connect()
  }
  if (is.null(repository)) {
    cli_alert_info("Detecting repository from git remote...")
    remote_info <- gert::git_remote_info()
    repository <- remote_info$url
    repository <- sub("\\.git", "", repository)
    cli_alert_success("Repository: {.url {repository}}")
  }
  if (file_exists(path(content_location, "manifest.json"))) {
    cli_alert_info("Deploying single content item...")
    deploy_single(content_location, client, repository, branch)
  } else {
    folders <- dir_ls(content_location, type = "directory")
    cli_alert_info("Found {length(folders)} subfolder{?s} to process")
    for (folder in folders) {
      deploy_single(content_location, client, repository, branch, folder)
    }
  }
  cli_alert_success("Deployment complete")
}

# Internal function to deploy a single content item
# @param content_location Base content location path
# @param client Posit Connect client object
# @param repository Git repository URL
# @param branch Git branch name
# @param sub_folder Optional subfolder name within content_location
# @return The content item object (invisibly), or NULL if skipped
deploy_single <- function(
  content_location,
  client,
  repository,
  branch,
  sub_folder = NULL
) {
  if (is.null(sub_folder)) {
    content_folder <- path(content_location)
    folder_name <- path_file(path_abs(content_location))
  } else {
    content_folder <- path(content_location, sub_folder)
    folder_name <- path_file(sub_folder)
  }

  if (!file_exists(path(content_folder, "manifest.json"))) {
    cli_alert_warning("Skipping '{folder_name}' - no manifest.json found")
    return(NULL)
  }

  metadata <- yaml::read_yaml(path(content_folder, "metadata.yml"))
  connect_file <- path(content_folder, ".connect")

  if (file_exists(connect_file)) {
    target_guid <- readLines(connect_file)
    cli_alert_info(
      "Updating '{metadata$title}' (GUID: {substr(target_guid, 1, 8)}...)"
    )
    item <- content_item(client, target_guid)
  } else {
    cli_alert_info("Deploying '{metadata$title}' as new content...")
    item <- deploy_repo(
      client = client,
      repository = repository,
      branch = branch,
      subdirectory = path_file(content_folder),
      title = paste("Access to Care -", metadata$title)
    )
    writeLines(item$content$guid, path(content_folder, ".connect"))
    cli_alert_success(
      "Created .connect file with GUID: {substr(item$content$guid, 1, 8)}..."
    )
  }

  thumbnail_file <- path(content_folder, "thumbnail.png")
  if (file_exists(thumbnail_file)) {
    cli_text("  {col_cyan('---')} Setting thumbnail")
    set_thumbnail(item, thumbnail_file)
  }

  name_url <- metadata$url
  if (!is.null(name_url)) {
    path_url <- paste0("/access-to-care/", name_url)
    cli_text("  {col_cyan('---')} Setting vanity URL: {.url {path_url}}")
    res <- set_vanity_url(item, path_url)
  }

  cli_alert_success("Deployed '{metadata$title}'")
  invisible(item)
}
