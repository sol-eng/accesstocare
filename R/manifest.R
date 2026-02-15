#' Prepare Git-backed deployment manifests
#' @description Intelligently creates manifest files for Posit Connect Git-backed
#' deployment. If the folder contains a primary document, creates a manifest for
#' that folder. If not, checks subfolders (one level deep) and creates manifests
#' for each subfolder with a primary document.
#'
#' @param folder_location The folder containing content to prepare for deployment
#' @param primary_document An optional argument. If passed, the function will
#' use that as the name of the primary document
#' @param ignore_files A list of files to be disregarded when creating the
#' manifest file.
#' @param silent To run with or without console updates
#'
#' @export
prepare_git_backed <- function(
  folder_location = ".",
  primary_document = NULL,
  ignore_files = list(
    "config.yml",
    ".gitignore",
    "manifest.json",
    ".DS_Store"
  ),
  silent = FALSE
) {
  full_path <- path_abs(folder_location)

  # Check if this folder has a primary document
  primary_doc <- primary_document
  if (is.null(primary_doc)) {
    primary_doc <- primary_docs(full_path)
  }

  # If folder has primary doc, create manifest for it
  if (!is.na(primary_doc)) {
    result <- create_single_manifest(
      folder_location = full_path,
      primary_document = primary_doc,
      ignore_files = ignore_files,
      silent = silent
    )
    return(invisible(result))
  }

  # No primary doc found, check subfolders (one level only)
  subfolders <- dir_ls(full_path, type = "directory")

  if (length(subfolders) == 0) {
    if (!silent) {
      cli_alert_warning("No primary document found and no subfolders to check")
    }
    return(invisible(NULL))
  }

  # Find subfolders with primary documents
  folders_with_primary <- keep(
    subfolders,
    ~ !is.na(primary_docs(.x))
  )

  if (length(folders_with_primary) == 0) {
    if (!silent) {
      cli_alert_warning("No primary documents found in subfolders")
    }
    return(invisible(NULL))
  }

  # If interactive, prompt for confirmation
  if (interactive() && !silent) {
    cli_alert_info(
      "Found {length(folders_with_primary)} subfolder{?s} with primary documents:"
    )
    walk(folders_with_primary, ~ cli_text("  - {path_file(.x)}"))

    response <- readline(
      prompt = "Create manifests for all subfolders? (y/n): "
    )
    if (!tolower(response) %in% c("y", "yes")) {
      cli_alert_info("Cancelled")
      return(invisible(NULL))
    }
  }

  # Create manifests for all qualifying subfolders
  results <- map(
    folders_with_primary,
    ~ {
      res <- create_single_manifest(
        folder_location = .x,
        primary_document = NULL,
        ignore_files = ignore_files,
        silent = TRUE
      )
      created <- ifelse(!is.null(res), "YES", "SKIPPED")
      tibble(
        content = path_file(.x),
        created = created
      )
    }
  )

  result_table <- tibble(
    content = map_chr(results, ~ .x$content),
    created = map_chr(results, ~ .x$created)
  )

  if (!silent) {
    cli_alert_success(
      "Created {sum(result_table$created == 'YES')} manifest{?s}"
    )
  }

  invisible(result_table)
}

# Internal function to create a single manifest
create_single_manifest <- function(
  folder_location,
  primary_document = NULL,
  ignore_files = list(
    "config.yml",
    ".gitignore",
    "manifest.json",
    ".DS_Store"
  ),
  silent = FALSE
) {
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
      if (!silent) cli_alert_danger("No identified primary doc")
    }
  }
  if (!silent) {
    cli_alert_success("Full path: {full_path}")
    cli_alert_info("Application files")
    walk(
      app_file_names,
      ~ cli_text("  {col_cyan('---')} {.x}")
    )
    cli_text("{col_red('Primary file:')} {col_cyan(primary_doc)}")
    cli_alert("Compiling manifest...")
  }

  # Check if this is a Python Dash app
  folder_name <- path_file(full_path)
  if (folder_name == "dash" && primary_doc == "app.py") {
    # Use reticulate::uv_run_tool for Python Dash apps
    cmd <- paste("write-manifest", folder_name, full_path)
    reticulate::uv_run_tool(
      "rsconnect",
      cmd,
      with = c("dash", "plotly", "polars")
    )
  } else {
    # Use rsconnect::writeManifest for R content
    app_mode <- NULL
    if (primary_doc == "plumber.R") {
      app_mode <- "api"
    }

    rsconnect::writeManifest(
      appDir = full_path,
      appFiles = app_file_names,
      appPrimaryDoc = primary_doc,
      appMode = app_mode
    )
  }

  if (!silent) {
    cli_alert_success("Manifest complete")
  }
  mf <- path(full_path, "manifest.json")
  if (file_exists(mf)) {
    mf
  } else {
    NULL
  }
}

primary_docs <- function(full_path) {
  pf <- map(
    c("*.Rmd", "*.py", "*app.R", "*.ipynb", "*plumber.R", "*map.html"),
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
  if (length(pd) > 1) {
    res <- NA
  }
  if (length(pd) == 1) {
    res <- pd
  }
  res
}
