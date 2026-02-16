#' @export
deploy_git_backed <- function(
  repository = NULL,
  branch = "main",
  content_location = ".",
  client = NULL
) {
  if (is.null(client)) {
    client <- connectapi::connect()
  }
  if (is.null(repository)) {
    remote_info <- gert::git_remote_info()
    repository <- remote_info$url
    # message: getting repo url from git
    repository <- sub("\\.git", "", repository)
  }
  connect_file <- path(content_location, ".connect")
  if (file_exists(connect_file)) {
    deploy_single(content_location, client, repository, branch)
  } else {
    folders <- dir_ls(content_location, type = "directory")
    for (folder in folders) {
      deploy_single(content_location, client, repository, branch, folder)
    }
  }
}

deploy_single <- function(
  content_location,
  client,
  repository,
  branch,
  sub_folder = NULL
) {
  if (is.null(sub_folder)) {
    content_folder <- path(content_location)
  } else {
    content_folder <- path(content_location, sub_folder)
  }
  if (!file_exists(path(content_folder, "manifest.json"))) {
    # Warning skip
    return(NULL)
  }
  metadata <- yaml::read_yaml(path(content_folder, "metadata.yml"))
  connect_file <- path(content_folder, ".connect")
  if (file_exists(connect_file)) {
    target_guid <- readLines(connect_file)
    item <- content_item(client, target_guid)
  } else {
    item <- deploy_repo(
      client = client,
      repository = repository,
      branch = branch,
      subdirectory = path_file(content_folder),
      title = paste("Access to Care -", metadata$title)
    )
    writeLines(item$content$guid, path(content_folder, ".connect"))
  }
  thumbnail_file <- path(content_folder, "thumbnail.png")
  if (file_exists(thumbnail_file)) {
    set_thumbnail(item, thumbnail_file)
  }
  name_url <- metadata$url
  if (!is.null(name_url)) {
    path_url <- paste0("/access-to-care/", name_url)
    res <- set_vanity_url(item, path_url)
  }
}
