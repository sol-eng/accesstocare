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
    sort(dir_ls(content_location, type = "directory")),
    ~ {
      description <- ""
      type <- ""
      if (file_exists(path(.x, "metadata.yml"))) {
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
print.metadata_list <- function(x, ...) {
  cat(bold(
    "No. ", 
    set_console_width("Name", 25), 
    "Type", "\n"
    ))
  purrr::iwalk(x, ~ cat(
    set_console_width(.y, 4),
    set_console_width(.x[[1]], 25),
    .x[[3]], "\n"
  ))
  invisible(x)
}

#' Copies the Access To Care examples
#' @param target_folder A folder location to transfer the examples to
#' @param content_no Select which content folder to copy
#' @param silent Send updates to the console
#' @export
atc_package_copy_content <- function(target_folder = here::here(),
                                     silent = FALSE,
                                     content_no = NULL) {
  ac <- atc_package_content()
  
  copt <- length(ac) + 1

  if (is.null(content_no)) {
    print(ac)
    cat(red(
      set_console_width(copt, 4), 
      set_console_width("Cancel", 25), 
      "", "\n")
      )
    if (interactive()) {
      content_no <- readline(prompt = "Enter the content number to copy: ")
    } else {
      return(NA)
    }
  }
  if(content_no == copt) return("Cancelled")
  full_file_copy(
    ac[[content_no]]$full_path,
    path(target_folder, path_file(ac[[content_no]]$full_path)),
    silent = silent
  )
}

#' @rdname atc_package_copy_content
#' @export
atc_package_copy_all_content <- function(target_folder = here::here(),
                                         silent = FALSE,
                                         content_no = NULL) {
  full_file_copy(
    system.file(package = "accesstocare", "content"),
    target_folder,
    silent = silent
  )
}

set_console_width <- function(x, size = 10) {
  if (nchar(x) < size) {
    spad <- paste0(rep(" ", size - nchar(x)), collapse = "")
    paste0(x, spad)
  } else {
    substr(x, 1, size)
  }
}
