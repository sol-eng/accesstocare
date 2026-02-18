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
#' @param skip_if_exists Skips content folder if it already exists. Defaults to
#' TRUE. Change to FALSE if you need to replace the thumbnail or update the
#' Vanity URL.
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
  client = NULL,
  skip_if_exists = TRUE
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
  if (file_exists(path(content_location, "metadata.yml"))) {
    cli_alert_info("Deploying single content item...")
    deploy_single(content_location, client, repository, branch)
  } else {
    folders <- dir_ls(content_location, type = "directory")
    cli_alert_info("Found {length(folders)} subfolder{?s} to process")
    for (folder in folders) {
      deploy_single(
        content_location = content_location,
        client = client,
        repository = repository,
        branch = branch,
        sub_folder = path_file(folder),
        skip_if_exists = skip_if_exists
      )
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
  sub_folder = NULL,
  skip_if_exists = TRUE
) {
  if (is.null(sub_folder)) {
    content_folder <- path(content_location)
    folder_name <- path_file(path_abs(content_location))
  } else {
    content_folder <- path(content_location, sub_folder)
    folder_name <- path_file(sub_folder)
  }
  if (
    !file_exists(path(content_folder, "manifest.json")) &
      !grepl("pins-", folder_name)
  ) {
    cli_alert_warning("Skipping '{folder_name}' - no manifest.json found")
    return(NULL)
  }
  metadata <- yaml::read_yaml(path(content_folder, "metadata.yml"))
  content_title <- paste0("Access to Care - ", metadata$title)
  connect_file <- path(content_folder, ".connect")
  if (!grepl("pins-", folder_name)) {
    if (file_exists(connect_file)) {
      target_guid <- readLines(connect_file)
      if (skip_if_exists) {
        cli_alert_warning("Skipping '{folder_name}' - content exists")
        return(NULL)
      }
      cli_alert_info(
        "Updating thumbnail and vanity URL for '{metadata$title}' (GUID: {substr(target_guid, 1, 8)}...)"
      )
      item <- content_item(client, target_guid)
    } else {
      cli_alert_info("Deploying '{metadata$title}' as new content...")
      item <- deploy_repo(
        client = client,
        repository = repository,
        branch = branch,
        subdirectory = path_file(content_folder),
        title = content_title
      )
      writeLines(item$content$guid, path(content_folder, ".connect"))
      cli_alert_success(
        "Created .connect file with GUID: {substr(item$content$guid, 1, 8)}..."
      )
    }
  } else {
    board_connect <- board_connect(
      server = client$server,
      key = client$api_key
    )
    content <- metadata$primary
    cli_alert_info("Uploading '{metadata$title}' ...")
    content_name <- path_ext_remove(content)
    if (metadata$type == "Model") {
      model_path <- path(content_folder, content)
      model_obj <- readRDS(model_path)
      vetiver_obj <- vetiver_model(
        model = model_obj,
        model_name = content_name,
        description = metadata$description
      )
      vetiver_pin_write(board_connect, vetiver_obj)
      metadata_vetiver <- yaml::read_yaml(path(
        content_folder,
        "metadata-1.yml"
      ))
      content_title <- paste0(content_name, ": a pinned list")
      vetiver_title <- paste0("Access to Care - ", metadata_vetiver$title)
      me <- client$me()
      vetiver_deploy_rsconnect(
        board = board_connect,
        name = paste0(me$username, "/", content_name),
        appTitle = vetiver_title
      )
      vetiver_item <- deploy_get_item(
        client,
        content_name = NULL,
        vetiver_title,
        ""
      )
      deploy_set_thumbnail(vetiver_item, content_folder, "thumbnail-1.png")
      deploy_set_vanity(vetiver_item, metadata_vetiver$url)
    } else {
      upload_pin <- pin_upload(
        board = board_connect,
        paths = path(content_folder, content),
        title = content_title,
        description = metadata$description,
        name = content_name
      )
    }
    item <- deploy_get_item(client, content_name, content_title, "pin")
  }
  if (is.null(item)) {
    return(NULL)
  }
  deploy_set_thumbnail(item, content_folder, "thumbnail.png")
  deploy_set_vanity(item, metadata$url)
  cli_alert_success("Deployed '{content_title}'")
  invisible(item)
}

deploy_get_item <- function(client, content_name, content_title, category) {
  tbl_content <- get_content(client, name = content_name)
  tbl_content <- tbl_content[!is.na(tbl_content$title), ]
  tbl_content <- tbl_content[tbl_content$title == content_title, ]
  tbl_content <- tbl_content[tbl_content$content_category == category, ]
  if (nrow(tbl_content) == 1) {
    item <- content_item(client, tbl_content$guid)
  } else {
    cli_alert_warning("Skipping '{content_name}' - thumbnail and vanity URL")
    return(NULL)
  }
}

deploy_set_thumbnail <- function(item, content_folder, file_name) {
  thumbnail_file <- path(content_folder, file_name)
  if (file_exists(thumbnail_file)) {
    cli_text("  {col_cyan('---')} Setting thumbnail")
    set_thumbnail(item, thumbnail_file)
  }
  return(invisible())
}

deploy_set_vanity <- function(item, name_url) {
  if (!is.null(name_url)) {
    path_url <- paste0("/access-to-care/", name_url)
    cli_text("  {col_cyan('---')} Setting vanity URL: {.url {path_url}}")
    res <- set_vanity_url(item, path_url)
  }
  return(invisible())
}
