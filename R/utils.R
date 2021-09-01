#' Returns a abbreviated version of a large number
#' @description It will return 1K if passed 1000.
#' @param x A number
#' @param round_digits Number of digits to round. Defaults to 0.
#'
#' @export
format_number <- function(x, round_digits = 0) {
  res <- x
  nf <- c(1000, 1000000, 1000000000)
  sf <- c("K", "M", "B")
  for (i in 1:3) {
    res[x >= nf[i]] <- paste0(
      round(x[x >= nf[i]] / nf[i], digits = round_digits), sf[i]
    )
  }
  res
}

#' @rdname format_number
#' @export
format_currency <- function(x, round_digits = 0) {
  res <- format_number(
    x = x,
    round_digits = round_digits
  )
  paste0("$", res)
}


toc <- function(readme_file = "README.Rmd") {
  re <- readLines(readme_file)
  has_title <- as.logical(lapply(re, function(x) substr(x, 1, 2) == "##"))
  only_titles <- re[has_title]
  titles <- trimws(gsub("#", "", only_titles))
  links <- trimws(gsub("`", "", titles))
  links <- tolower(links)
  links <- trimws(gsub(" ", "-", links))
  links <- trimws(gsub("\\.", "-", links))
  links <- trimws(gsub("\\,", "", links))
  toc_list <- lapply(
    seq_along(titles),
    function(x) {
      pad <- ifelse(substr(only_titles[x], 1, 3) == "###", "    - ", "  - ")
      paste0(pad, "[", titles[x], "](#",links[x], ")")
    }
  )
  toc_full <- paste(toc_list, collapse = "\n") 
  cat(toc_full)
}