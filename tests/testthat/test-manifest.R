test_that("Single folder manifest is created", {
  temp_folder <- paste0(tempdir(), "/atc-manifest-single")
  temp_html <- paste0(temp_folder, "/html")
  dir.create(temp_folder, showWarnings = FALSE)
  dir.create(temp_html, showWarnings = FALSE)

  writeLines("<p>", con = paste0(temp_html, "/test-map.html"))
  writeLines("config.yml", con = paste0(temp_html, "/.gitignore"))

  # Should create manifest for single folder with primary doc
  create_manifests(
    temp_html,
    silent = FALSE
  )

  expect_true(
    file.exists(paste0(temp_html, "/manifest.json"))
  )

  unlink(temp_folder, recursive = TRUE, force = TRUE)
})

test_that("Multiple subfolder manifests are created", {
  temp_folder <- paste0(tempdir(), "/atc-manifest-multi")
  temp_shiny <- paste0(temp_folder, "/shiny")
  temp_rmd <- paste0(temp_folder, "/rmd")
  dir.create(temp_folder, showWarnings = FALSE)
  dir.create(temp_shiny, showWarnings = FALSE)
  dir.create(temp_rmd, showWarnings = FALSE)

  writeLines("library(shiny)", con = paste0(temp_shiny, "/app.R"))
  writeLines("# Title", con = paste0(temp_rmd, "/report.Rmd"))

  # Should create manifests for subfolders (non-interactive test, silent = TRUE)
  res <- create_manifests(temp_folder, silent = TRUE)

  expect_s3_class(res, "tbl_df")
  expect_equal(nrow(res), 2)
  expect_true(file.exists(paste0(temp_shiny, "/manifest.json")))
  expect_true(file.exists(paste0(temp_rmd, "/manifest.json")))

  unlink(temp_folder, recursive = TRUE, force = TRUE)
})

test_that("No manifest created without primary doc", {
  temp_folder <- paste0(tempdir(), "/atc-manifest-none")
  temp_subfolder <- paste0(temp_folder, "/subfolder")
  dir.create(temp_folder, showWarnings = FALSE)
  dir.create(temp_subfolder, showWarnings = FALSE)

  writeLines("just text", con = paste0(temp_subfolder, "/readme.txt"))

  # Should return NULL when no primary docs found
  res <- create_manifests(temp_folder, silent = TRUE)

  expect_null(res)
  expect_false(file.exists(paste0(temp_subfolder, "/manifest.json")))

  unlink(temp_folder, recursive = TRUE, force = TRUE)
})

test_that("README.Rmd is excluded as primary doc", {
  temp_folder <- paste0(tempdir(), "/atc-manifest-readme")
  dir.create(temp_folder, showWarnings = FALSE)

  # Create only a README.Rmd file
  writeLines("# README", con = paste0(temp_folder, "/README.Rmd"))

  # Should return NULL since README.Rmd is not deployable
  res <- create_manifests(temp_folder, silent = TRUE)

  expect_null(res)
  expect_false(file.exists(paste0(temp_folder, "/manifest.json")))

  unlink(temp_folder, recursive = TRUE, force = TRUE)
})
