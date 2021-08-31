test_that("Manifests are being written to content folder", {
  temp_folder <- paste0(tempdir(), "/atc-manifest-test")
  temp_html <- paste0(temp_folder, "/html")
  temp_other <- paste0(temp_folder, "/other")
  dir.create(temp_folder)
  dir.create(temp_html)
  dir.create(temp_other)

  writeLines("<p>", con = paste0(temp_html, "/test.html"))
  writeLines("config.yml", con = paste0(temp_html, "/.gitignore"))

  res <- atc_write_all_manifests(temp_folder)

  atc_write_manifest(
    temp_html,
    primary_document = "test.html",
    silent = FALSE
  )

  expect_length(
    res,
    2
  )

  expect_length(
    dir(temp_html),
    2
  )

  unlink(temp_folder, recursive = TRUE, force = TRUE)

  expect_length(
    dir(temp_folder),
    0
  )
})
