#' @export
create_content <- function(
  target = ".",
  content = c(
    "all",
    "connectwidgets",
    "dash",
    "htmlwidgets",
    "jupyter",
    "plot",
    "plumber-api",
    "presentation",
    "quarto-dashboard-r",
    "RMarkdown-html",
    "RMarkdown-pdf",
    "shiny"
  ),
  silent = FALSE
) {
  content <- content[[1]]
  content_folders <- dir_ls(content_folder())
  for (folder in content_folders) {
    content_name <- path_file(folder)
    if (content == content_name | content == "all") {
      dir_copy(folder, path(target, content_name))
    }
  }
  if (content %in% c("all", "plot")) {
    p <- atc_plot_state_map("All US", top_cities = 0)
    dest_folder <- path(target, "plot")
    dir_create(dest_folder)
    ggsave(plot = p, filename = path(dest_folder, "map.png"))
    writeLines(
      "<img src=map.png width = 1000>",
      con = path(target, "plot", "map.html")
    )
  }
  if (content %in% c("all", "htmlwidgets")) {
    p <- atc_plot_state_map("All US", top_cities = 0)
    gp <- girafe(ggobj = p)
    dest_folder <- path(target, "htmlwidgets")
    dir_create(dest_folder)
    saveWidget(gp, path(dest_folder, "map.html"))
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
  contents <- c("all", folder_names, "htmlwidgets", "plot")
  cat(paste0("\"", sort(contents), "\"", collapse = ", "))
}
