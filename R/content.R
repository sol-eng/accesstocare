#' @export
atc_content_package <- function() {
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
    class = c("atc_content_list", "list")
  ))
}

#' @export
print.atc_content_list <- function(x, ...) {
  print(map_dfr(x, ~.x))
  invisible(x)
}

