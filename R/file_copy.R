full_file_copy <- function(folder, new_folder, exclude_exts = NULL, silent = FALSE) {
  if (!dir_exists(new_folder)) dir_create(new_folder)
  fls <- sanitized_file_list(
    folder = folder,
    exclude_exts = exclude_exts
  )
  fd <- path(new_folder, folder_list(fls))
  dir_create(fd[!dir_exists(fd)])
  walk(
    fls, 
    ~ {
      new_file <- path(new_folder, .x)
      if(!file_exists(new_file)) {
        file_copy(path(folder, .x), new_file)  
        if(!silent) cat(green(paste0(new_file, " - copied\n")))
      } else {
        if(!silent) cat(red(paste0(new_file, " - already exists\n")))
      }
    } 
    )
}

folder_list <- function(file_list) {
  dj <- as_fs_path(unique(path_dir(file_list)))
  dj[dj != "."]
}

full_file_list <- function(folder, exclude_exts = NULL) {
  fc <- dir_ls(folder, recurse = TRUE, all = TRUE)
  if (!is.null(exclude_exts)) {
    for (i in 1:length(exclude_exts)) {
      fc <- fc[path_ext(fc) != exclude_exts[i]]
    }
  }
  fc
}

sanitized_file_list <- function(folder, exclude_exts = NULL) {
  fc <- full_file_list(
    folder = folder,
    exclude_exts = exclude_exts
  )
  pl <- length(path_split(path_common(fc))[[1]])
  fcs <- path_split(fc)
  rf <- map(fcs, ~ .x[(pl + 1):length(.x)])
  rj <- path_join(rf)
  rj[is_file(fc)]
}