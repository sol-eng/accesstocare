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
create_git_backed <- function(
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
  # Check if this is a Python app
  folder_name <- path_file(full_path)
  if (folder_name == "app-python" && primary_doc == "app.py") {
    py_manifest(
      "dash",
      full_path,
      c("dash", "dash-bootstrap-components", "plotly", "polars")
    )
  } else if (folder_name == "api-python" && primary_doc == "main.py") {
    py_manifest(
      "fastapi",
      full_path,
      c("fastapi", "uvicorn[standard]", "polars", "pyarrow")
    )
  } else if (
    folder_name == "dashboard-python" && grepl("\\.qmd$", primary_doc)
  ) {
    qmd_file <- path(full_path, primary_doc)
    py_manifest(
      "quarto",
      qmd_file,
      c("polars", "plotly", "shiny", "shinywidgets", "numpy")
    )
  } else if (
    folder_name == "presentation-python" && grepl("\\.qmd$", primary_doc)
  ) {
    qmd_file <- path(full_path, primary_doc)
    py_manifest(
      "quarto",
      qmd_file,
      c("polars", "plotnine", "pyarrow", "great-tables")
    )
  } else if (folder_name == "report-python" && grepl("\\.qmd$", primary_doc)) {
    qmd_file <- path(full_path, primary_doc)
    py_manifest(
      "quarto",
      qmd_file,
      c("polars", "plotnine", "pyarrow", "great-tables")
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
      appMode = app_mode,
      quiet = TRUE
    )
    if (!silent) {
      cli_alert_info("Manifest for '{path_file(folder_location)}' created")
    }
  }
  mf <- path(full_path, "manifest.json")
  if (file_exists(mf)) {
    mf
  } else {
    NULL
  }
}

# Internal helper function to create Python manifests using rsconnect
# @param command_type The rsconnect command type (dash, fastapi, quarto)
# @param target_path The path to the content (directory for apps, file for quarto)
# @param libraries Character vector of Python packages to include
py_manifest <- function(command_type, target_path, libraries) {
  cmd <- paste("write-manifest", command_type, target_path)
  reticulate::uv_run_tool(
    "rsconnect",
    cmd,
    with = libraries
  )
}

primary_docs <- function(full_path) {
  pf <- map(
    c("*.Rmd", "*.qmd", "*.py", "*app.R", "*.ipynb", "*plumber.R", "*map.html"),
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

  # Exclude README.Rmd as it's not deployable content
  pd <- pd[pd != "README.Rmd"]

  if (length(pd) == 0) {
    return(NA)
  }
  if (length(pd) > 1) {
    res <- NA
  }
  if (length(pd) == 1) {
    res <- pd
  }
  res
}
