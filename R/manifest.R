#' Prepares manifest file
#' @description A convinience function that simplifies the creation of the
#' manifest file needed for publication.
#'
#' @param folder_location The folder containing the files of a single asset to
#' be published
#' @param primary_document An optional argument. If passed, the function will
#' use that as the name of the primary document
#' @param ignore_files A list of files to be disregarded when creating the
#' manifest file.
#' @param silent To run with or without console updates
#'
#' @export
atc_write_manifest <- function(folder_location,
                               primary_document = NULL,
                               ignore_files = list(
                                 "config.yml", ".gitignore",
                                 "manifest.json", ".DS_Store",
                                 ".gitignore"
                               ),
                               silent = FALSE) {
  full_path <- path_abs(folder_location)
  app_files <- dir_ls(full_path, all = TRUE)

  app_file_names <- path_file(app_files)

  git_ignore <- app_files[app_file_names == ".gitignore"]
  if (length(git_ignore) > 0) {
    git_files <- readLines(git_ignore)
  } else {
    git_files <- ""
  }
  ig <- c(ignore_files, git_files)
  for (i in seq_along(ig)) {
    app_file_names <- app_file_names[app_file_names != ig[i]]
  }

  primary_doc <- primary_document

  if (is.null(primary_doc)) {
    primary_doc <- primary_docs(full_path)
    if (is.na(primary_doc)) {
      return(NULL)
      if (!silent) cat(red("No identifies primary doc"))
    }
  }
  if (!silent) {
    cat(green("Full path: ", full_path, "\n"))
    cat(red("Application files\n"))
    walk(
      app_file_names,
      ~ cat(cyan("--- ", .x, "\n"))
    )
    cat(paste0(red("Primary file: "), cyan(primary_doc, "\n")))
    cat(magenta("Compiling manifest...\n"))
  }

  rsconnect::writeManifest(
    appDir = full_path,
    appFiles = app_file_names,
    appPrimaryDoc = primary_doc
  )
  if (!silent) cat(magenta("Manifest complete\n\n"))
  mf <- path(full_path, "manifest.json")
  if (file_exists(mf)) {
    mf
  } else {
    NULL
  }
}

#' Batch creation of manifests
#' @description Attempts to create manifests for all sub-folders inside a given
#' content folder.
#' @param content_folder The root folder location.
#' @export
atc_write_all_manifests <- function(content_folder = ".") {
  t <- map(
    dir_ls(content_folder, type = "directory"),
    ~ {
      res <- atc_write_manifest(.x, silent = TRUE)
      created <- ifelse(!is.null(res), "YES", "SKIPPED")
      tibble(
        content = path_file(.x),
        created = created
      )
    }
  )
  tibble(
    content = map_chr(t, ~ .x$content),
    created = map_chr(t, ~ .x$created)
  )
}

primary_docs <- function(full_path) {
  pf <- map(
    c("*.Rmd", "*.py", "*app.R", "*.ipynb", "*plumber.R"),
    ~ {
      dl <- dir_ls(full_path, glob = .x)
      path_file(dl)
    }
  )
  pd <- keep(
    pf,
    ~ length(.x) > 0
  )
  if (length(pd) == 0) {
    return(NA)
  }
  pd <- pd[[1]]
  if (length(pd) > 1) res <- NA
  if (length(pd) == 1) res <- pd
  res
}
