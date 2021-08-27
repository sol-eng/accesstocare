#' @export
atc_package_content <- function() {
  folder_content_metadata(system.file(package = "accesstocare", "content"))
}

#' @export
folder_content_metadata <- function(location = ".") {
  atl <- map(
    dir_ls(location, type = "directory"), 
    ~{
      description <- ""
      type <- ""
      if(file_exists(path(.x, "metadata.yml"))) {
        mt <- read_yaml(path(.x, "metadata.yml")) 
        description <- mt$description
        type <- mt$type
      }
      list(
        name = path_file(.x),
        description = description,
        type = type,
        full_path = .x
      )
    }
  )
  atl <- set_names(atl, seq_along(atl)) 
  return(structure(
    atl,
    class = c("metadata_list", "list")
  ))
}

#' @export
as_tibble.metadata_list <- function(x) {
  map_dfr(x, ~.x)
}

#' @export
print.metadata_list <- function(x, ...) {
  print(as_tibble(x))
  invisible(x)
}

#' @export
atc_package_content_copy <- function(target_folder = here::here()) {
  content_path <- system.file(package = "accesstocare", "content")
  full_file_copy(content_path, target_folder)
}