#' A list of the Access To Care examples
#' @export
atc_package_content <- function() {
  folder_content_metadata(
    system.file(package = "accesstocare", "content")
    )
}

#' A list of examples in a folder
#' @description It uses the information from the 'metadata.yml' file to create
#' a list containing the name, description, type and path of each
#' example content. 
#' @param content_location The root folder of where the examples are located
#' @export
folder_content_metadata <- function(content_location = ".") {
  atl <- map(
    dir_ls(content_location, type = "directory"), 
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

#' Copies the Access To Care examples
#' @param target_folder A folder location to transfer the examples to
#' @export
atc_package_content_copy <- function(target_folder = here::here()) {
  full_file_copy(
    system.file(package = "accesstocare", "content"), 
    target_folder
    )
}