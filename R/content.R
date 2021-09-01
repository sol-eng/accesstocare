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
  cat(bold("No. ", print_w("Name", 25), "Type", "\n"))
  purrr::iwalk(x, ~ cat(print_w(.y, 4), print_w(.x[[1]], 25),.x[[3]], "\n"))
  invisible(x)
}

#' Opens an examples in RSTudio
#' @param content_no Select which content folder to copy
#' @param silent Send updates to the console
#' @export
atc_open_content <- function(content_no = NULL, 
                             silent = TRUE
) {
  package_copy_content(
    content_no = content_no,
    target_folder = tempdir(),
    silent = silent,
    open = TRUE,
    open_fail = TRUE
  )
} 

#' Copies the Access To Care examples
#' @param target_folder A folder location to transfer the examples to
#' @param content_no Select which content folder to copy
#' @param silent Send updates to the console
#' @export
atc_copy_content <- function(content_no = NULL, 
                                     target_folder = here::here(),
                                     silent = FALSE
                                     ) {
  package_copy_content(
    content_no = content_no,
    target_folder = target_folder,
    silent = silent
  )
} 

#' @rdname atc_copy_content
#' @export
atc_copy_all_content <- function(target_folder = here::here(),
                                         silent = FALSE
                                         ) {
  full_file_copy(
    system.file(package = "accesstocare", "content"),
    target_folder,
    silent = silent
  )
}

package_copy_content <- function(content_no = NULL, 
                                 target_folder = here::here(),
                                 silent = FALSE,
                                 open = FALSE, 
                                 open_fail = FALSE
) { 
  ac <- atc_package_content()
  copt <- length(ac) + 1
  if (is.null(content_no)) {
    print(ac)
    cat(red(print_w(copt, 4), print_w("Cancel", 25), "", "\n"))
    if (interactive()) {
      content_no <- readline(prompt = "Enter the content number: ")
    } else {
      return(NA)
    }
  }
  if(content_no == copt) return("Cancelled")
  
  fp <- ac[[content_no]]$full_path
  pd <- primary_docs(fp)
  
  if(open_fail && open) {
    if(is.na(pd)) stop("No primary document identified, copy instead")
  }
  
  np <- path(target_folder, fp)
  
  full_file_copy(fp, np, silent = silent)
  
  if(open) navigateToFile(path(np, pd))
}

print_w <- function(x, size = 10) {
  if (nchar(x) < size) {
    spad <- paste0(rep(" ", size - nchar(x)), collapse = "")
    paste0(x, spad)
  } else {
    substr(x, 1, size)
  }
}
