#' Create Access To Care example content
#' @description Copies example content from the package to a target directory.
#' @param target The destination directory where content will be copied.
#' Defaults to current directory.
#' @param content Which content to copy. Can be "all" to copy everything, or
#' a specific content name. Available options include: "all", "api-python",
#' "api-r", "app-python", "app-r", "connectwidgets", "dashboard-python",
#' "dashboard-r", "pins-data", "pdf-r", "presentation-python", "presentation-r",
#' "r-htmlwidgets", "r-plot", "report-python", "report-r".
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
    "pins-data",
    "pdf-r",
    "presentation-python",
    "presentation-r",
    "r-htmlwidgets",
    "r-plot",
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
      folder_created <- FALSE

      if (!dir_exists(dest)) {
        dir_copy(folder, dest)
        folder_created <- TRUE
      } else if (force) {
        dir_delete(dest)
        dir_copy(folder, dest)
        folder_created <- TRUE
      } else if (!silent) {
        cli_alert_warning("Skipping '{content_name}' - folder already exists")
      }

      # Export data for Python examples (runs whether folder was just created or already exists)
      if (
        content_name == "app-python" && (folder_created || dir_exists(dest))
      ) {
        export_data_parquet("us_counties", dest, silent = silent)
      }

      if (
        content_name == "api-python" && (folder_created || dir_exists(dest))
      ) {
        export_data_parquet("us_counties", dest, silent = silent)
        export_data_parquet("us_states", dest, silent = silent)
      }

      if (
        content_name == "dashboard-python" &&
          (folder_created || dir_exists(dest))
      ) {
        export_data_parquet("us_counties", dest, silent = silent)
        export_data_parquet("us_states", dest, silent = silent)
        export_data_parquet("us_hex_positions", dest, silent = silent)
        export_data_parquet("us_atc_county_polygons", dest, silent = silent)
        export_data_parquet("us_large_cities", dest, silent = silent)
      }

      if (
        content_name == "presentation-python" &&
          (folder_created || dir_exists(dest))
      ) {
        export_data_parquet("us_counties", dest, silent = silent)
        export_data_parquet("us_states", dest, silent = silent)
        export_data_parquet("us_atc_county_polygons", dest, silent = silent)
        export_data_parquet("us_large_cities", dest, silent = silent)
      }

      if (
        content_name == "report-python" && (folder_created || dir_exists(dest))
      ) {
        export_data_parquet("us_counties", dest, silent = silent)
        export_data_parquet("us_states", dest, silent = silent)
        export_data_parquet("us_atc_county_polygons", dest, silent = silent)
        export_data_parquet("us_large_cities", dest, silent = silent)
      }
    }
  }
  if (content %in% c("all", "r-plot")) {
    dest_folder <- path(target, "r-plot")
    if (!dir_exists(dest_folder)) {
      p <- atc_plot_state_map("All US", top_cities = 0)
      dir_create(dest_folder)
      ggsave(plot = p, filename = path(dest_folder, "map.png"))
      writeLines(
        "<img src=map.png width = 1000>",
        con = path(dest_folder, "map.html")
      )
    } else if (force) {
      dir_delete(dest_folder)
      p <- atc_plot_state_map("All US", top_cities = 0)
      dir_create(dest_folder)
      ggsave(plot = p, filename = path(dest_folder, "map.png"))
      writeLines(
        "<img src=map.png width = 1000>",
        con = path(dest_folder, "map.html")
      )
    } else if (!silent) {
      cli_alert_warning("Skipping 'r-plot' - folder already exists")
    }
  }
  if (content %in% c("all", "r-htmlwidgets")) {
    dest_folder <- path(target, "r-htmlwidgets")
    if (!dir_exists(dest_folder)) {
      p <- atc_plot_state_map("All US", top_cities = 0)
      gp <- girafe(ggobj = p)
      dir_create(dest_folder)
      saveWidget(gp, path(dest_folder, "map.html"))
    } else if (force) {
      dir_delete(dest_folder)
      p <- atc_plot_state_map("All US", top_cities = 0)
      gp <- girafe(ggobj = p)
      dir_create(dest_folder)
      saveWidget(gp, path(dest_folder, "map.html"))
    } else if (!silent) {
      cli_alert_warning("Skipping 'r-htmlwidgets' - folder already exists")
    }
  }
  if (content %in% c("all", "pins-data")) {
    dest_folder <- path(target, "pins_data")
    if (!dir_exists(dest_folder)) {
      write.csv(us_counties, dest_folder)
    } else if (force) {
      dir_delete(dest_folder)
      dir_create(dest_folder)
      write.csv(us_counties, dest_folder)
    } else if (!silent) {
      cli_alert_warning("Skipping 'pins-data' - folder already exists")
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
  contents <- c("all", folder_names, "r-htmlwidgets", "r-plot")
  cat(paste0("\"", sort(contents), "\"", collapse = ", "))
}

# Internal function to export data as parquet for Python examples
export_data_parquet <- function(data_name, dest_folder, silent = FALSE) {
  # Get the data object
  data_obj <- get(data_name, envir = asNamespace("accesstocare"))

  # Create data subfolder if it doesn't exist
  data_folder <- path(dest_folder, "data")
  if (!dir_exists(data_folder)) {
    dir_create(data_folder)
  }

  # Write parquet file
  parquet_path <- path(data_folder, paste0(data_name, ".parquet"))
  arrow::write_parquet(data_obj, parquet_path)

  invisible(parquet_path)
}
