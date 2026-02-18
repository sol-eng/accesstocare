#' Create Access To Care example content
#' @description Copies example content from the package to a target directory.
#' @param target The destination directory where content will be copied.
#' Defaults to current directory.
#' @param content Which content to copy. Can be "all" to copy everything, or
#' a specific content name. Available options include: "all", "api-python",
#' "api-r", "app-python", "app-r", "connectwidgets", "dashboard-python",
#' "dashboard-r", "htmlwidgets-r", "pdf-r", "pins-data", "plot-r",
#' "presentation-python", "presentation-r", "report-python", "report-r".
#' @param force If TRUE, overwrites existing folders. If FALSE (default), skips
#' existing folders.
#' @param silent If TRUE, suppresses console messages. Defaults to FALSE.
#' @export
create_content <- function(
  target = ".",
  content = c(
    "all",
    "api-python",
    "api-r",
    "app-python",
    "app-r",
    "connectwidgets",
    "dashboard-python",
    "dashboard-r",
    "htmlwidgets-r",
    "pdf-r",
    "pins-data",
    "plot-r",
    "presentation-python",
    "presentation-r",
    "report-python",
    "report-r"
  ),
  force = FALSE,
  silent = FALSE
) {
  content <- match.arg(content)
  content_folders <- dir_ls(content_folder())
  for (folder in content_folders) {
    content_name <- path_file(folder)
    if (content == content_name | content == "all") {
      dest <- path(target, content_name)
      finalize_content <- FALSE
      if (!dir_exists(dest)) {
        dir_copy(folder, dest)
        finalize_content <- TRUE
      } else if (force) {
        clear_folder_contents(dest)
        dir_copy(folder, target)
        finalize_content <- TRUE
        cli_alert_info(
          "Writting '{content_name}' - replacing existing contents"
        )
      } else if (!silent) {
        cli_alert_warning("Skipping '{content_name}' - content already exists")
      }
      if (finalize_content) {
        if (content_name == "plot-r") {
          p <- atc_plot_state_map("All US", top_cities = 0)
          ggsave(plot = p, filename = path(dest, "map.png"))
          writeLines(
            "<img src=map.png width = 1000>",
            con = path(dest, "map.html")
          )
        }

        if (content_name == "htmlwidgets-r") {
          p <- atc_plot_state_map("All US", top_cities = 0)
          gp <- girafe(ggobj = p)
          saveWidget(gp, path(dest, "map.html"))
        }

        if (content_name == "pins-data") {
          data_obj <- get("us_counties", envir = asNamespace("accesstocare"))
          write.csv(data_obj, path(dest, "us_counties.csv"))
        }

        if (content_name == "app-python") {
          export_data_parquet("us_counties", dest)
        }

        if (content_name == "api-python") {
          export_data_parquet(c("us_counties", "us_states"), dest)
        }

        if (content_name == "dashboard-python") {
          export_data_parquet(
            c(
              "us_counties",
              "us_states",
              "us_hex_positions",
              "us_atc_county_polygons",
              "us_large_cities"
            ),
            dest
          )
        }

        if (content_name == "presentation-python") {
          export_data_parquet(
            c(
              "us_counties",
              "us_states",
              "us_atc_county_polygons",
              "us_large_cities"
            ),
            dest
          )
        }

        if (content_name == "report-python") {
          export_data_parquet(
            c(
              "us_counties",
              "us_states",
              "us_atc_county_polygons",
              "us_large_cities"
            ),
            dest
          )
        }
      }
    }
  }
}

content_folder <- function() {
  if (file_exists("./inst/content")) {
    path("./inst/content")
  } else {
    path(system.file(package = "accesstocare", "content"))
  }
}

get_contents <- function() {
  folder <- content_folder()
  folders <- dir_ls(folder)
  folder_names <- path_file(folders)
  contents <- c("all", folder_names, "htmlwidgets-r", "plot-r")
  cat(paste0("\"", sort(contents), "\"", collapse = ", "))
}

# Internal function to export data as parquet for Python examples
export_data_parquet <- function(data_names, dest_folder) {
  for (data_name in data_names) {
    # Get the data object
    data_obj <- get(data_name, envir = asNamespace("accesstocare"))

    # Create data subfolder if it doesn't exist
    data_folder <- path(dest_folder, "data")
    if (!dir_exists(data_folder)) {
      dir_create(data_folder)
    }

    # Write parquet file
    parquet_path <- path(data_folder, paste0(data_name, ".parquet"))
    if (!file.exists(parquet_path)) {
      arrow::write_parquet(data_obj, parquet_path)
    }
  }
  invisible()
}

# Internal function to clear folder contents while preserving .connect files
# @param folder_path Path to the folder to clear
# @return The folder path (invisibly)
clear_folder_contents <- function(folder_path) {
  # Ensure folder exists
  if (!dir_exists(folder_path)) {
    dir_create(folder_path)
    return(invisible(folder_path))
  }

  # Get all items in the folder
  all_items <- dir_ls(folder_path, all = TRUE, recurse = FALSE)

  # Filter out items containing ".connect" in their name
  items_to_delete <- all_items[!grepl("\\.connect", path_file(all_items))]

  # Delete each item
  walk(
    items_to_delete,
    ~ {
      if (dir_exists(.x)) {
        dir_delete(.x)
      } else if (file_exists(.x)) {
        file_delete(.x)
      }
    }
  )

  invisible(folder_path)
}
