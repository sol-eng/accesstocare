test_that("create_content copies single content", {
  temp_dir <- paste0(tempdir(), "/create-single")

  create_content(
    target = temp_dir,
    content = "app-r",
    silent = TRUE,
    manifest = FALSE
  )

  expect_true(dir.exists(file.path(temp_dir, "app-r")))
  expect_length(dir(temp_dir), 1)

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})

test_that("create_content copies all content", {
  temp_dir <- paste0(tempdir(), "/create-all")

  create_content(
    target = temp_dir,
    content = "all",
    silent = TRUE,
    manifest = FALSE
  )

  # Should have 15 inst/content folders (includes pins-data and pins-model)
  expect_gte(length(dir(temp_dir)), 15)

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})

test_that("create_content respects force=FALSE", {
  temp_dir <- paste0(tempdir(), "/create-force")

  # Create first time
  create_content(
    target = temp_dir,
    content = "app-r",
    silent = TRUE,
    manifest = FALSE
  )

  # Try to create again without force
  expect_warning(
    create_content(
      target = temp_dir,
      content = "app-r",
      silent = FALSE,
      manifest = FALSE
    ),
    NA # Expect no error, just skip
  )

  expect_length(dir(temp_dir), 1)

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})

test_that("create_content with force=TRUE overwrites", {
  temp_dir <- paste0(tempdir(), "/create-force-true")

  # Create first time
  create_content(
    target = temp_dir,
    content = "app-r",
    silent = TRUE,
    manifest = FALSE
  )

  # Create again with force
  create_content(
    target = temp_dir,
    content = "app-r",
    force = TRUE,
    silent = TRUE,
    manifest = FALSE
  )

  expect_true(dir.exists(file.path(temp_dir, "app-r")))

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})

test_that("create_content generates plot-r content", {
  temp_dir <- paste0(tempdir(), "/create-plot-r")

  create_content(
    target = temp_dir,
    content = "plot-r",
    silent = TRUE,
    manifest = FALSE
  )

  expect_true(dir.exists(file.path(temp_dir, "plot-r")))
  expect_true(file.exists(file.path(temp_dir, "plot-r", "map.png")))
  expect_true(file.exists(file.path(temp_dir, "plot-r", "map.html")))

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})

test_that("create_content generates htmlwidgets-r content", {
  temp_dir <- paste0(tempdir(), "/create-htmlwidgets-r")

  create_content(
    target = temp_dir,
    content = "htmlwidgets-r",
    silent = TRUE,
    manifest = FALSE
  )

  expect_true(dir.exists(file.path(temp_dir, "htmlwidgets-r")))
  expect_true(file.exists(file.path(temp_dir, "htmlwidgets-r", "map.html")))

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})

test_that("create_content generates pins-data content", {
  temp_dir <- paste0(tempdir(), "/create-pins-data")

  create_content(
    target = temp_dir,
    content = "pins-data",
    silent = TRUE,
    manifest = FALSE
  )

  expect_true(dir.exists(file.path(temp_dir, "pins-data")))
  expect_true(file.exists(file.path(temp_dir, "pins-data", "us_counties.csv")))

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})

test_that("create_content generates pins-model content", {
  temp_dir <- paste0(tempdir(), "/create-pins-model")

  create_content(
    target = temp_dir,
    content = "pins-model",
    silent = TRUE,
    manifest = FALSE
  )

  expect_true(dir.exists(file.path(temp_dir, "pins-model")))
  expect_true(file.exists(file.path(temp_dir, "pins-model", "us_atc_model.rds")))

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})

test_that("create_content exports parquet for app-python", {
  skip_if_not_installed("arrow")

  temp_dir <- paste0(tempdir(), "/create-app-python")

  create_content(
    target = temp_dir,
    content = "app-python",
    silent = TRUE,
    manifest = FALSE
  )

  expect_true(dir.exists(file.path(temp_dir, "app-python")))
  expect_true(dir.exists(file.path(temp_dir, "app-python", "data")))
  expect_true(file.exists(file.path(
    temp_dir,
    "app-python",
    "data",
    "us_counties.parquet"
  )))

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})

test_that("create_content exports parquet for api-python", {
  skip_if_not_installed("arrow")

  temp_dir <- paste0(tempdir(), "/create-api-python")

  create_content(
    target = temp_dir,
    content = "api-python",
    silent = TRUE,
    manifest = FALSE
  )

  expect_true(dir.exists(file.path(temp_dir, "api-python")))
  expect_true(dir.exists(file.path(temp_dir, "api-python", "data")))
  expect_true(file.exists(file.path(
    temp_dir,
    "api-python",
    "data",
    "us_counties.parquet"
  )))
  expect_true(file.exists(file.path(
    temp_dir,
    "api-python",
    "data",
    "us_states.parquet"
  )))
  expect_true(file.exists(file.path(temp_dir, "api-python", "main.py")))

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})

test_that("clear_folder_contents preserves .connect files", {
  temp_dir <- paste0(tempdir(), "/clear-folder-test")
  dir.create(temp_dir, showWarnings = FALSE)

  # Create various files
  writeLines("regular file", file.path(temp_dir, "regular.txt"))
  writeLines("connect file", file.path(temp_dir, "deployment.connect"))
  writeLines("another connect", file.path(temp_dir, ".connect-data"))
  dir.create(file.path(temp_dir, "subfolder"))
  writeLines("subfolder file", file.path(temp_dir, "subfolder", "data.txt"))

  # Call clear_folder_contents
  accesstocare:::clear_folder_contents(temp_dir)

  # Regular files should be deleted
  expect_false(file.exists(file.path(temp_dir, "regular.txt")))
  expect_false(dir.exists(file.path(temp_dir, "subfolder")))

  # .connect files should be preserved
  expect_true(file.exists(file.path(temp_dir, "deployment.connect")))
  expect_true(file.exists(file.path(temp_dir, ".connect-data")))

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})

test_that("clear_folder_contents creates folder if missing", {
  temp_dir <- paste0(tempdir(), "/clear-folder-missing")

  # Ensure folder doesn't exist
  if (dir.exists(temp_dir)) {
    unlink(temp_dir, recursive = TRUE)
  }

  # Call clear_folder_contents on non-existent folder
  accesstocare:::clear_folder_contents(temp_dir)

  # Folder should be created
  expect_true(dir.exists(temp_dir))

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})

test_that("create_content with force preserves .connect files", {
  temp_dir <- paste0(tempdir(), "/create-force-connect")

  # Create content first time
  create_content(
    target = temp_dir,
    content = "pins-data",
    silent = TRUE,
    manifest = FALSE
  )

  # Add a .connect file
  writeLines(
    "connect data",
    file.path(temp_dir, "pins-data", "deployment.connect")
  )

  # Force overwrite
  create_content(
    target = temp_dir,
    content = "pins-data",
    force = TRUE,
    silent = TRUE,
    manifest = FALSE
  )

  # Content should be recreated
  expect_true(file.exists(file.path(temp_dir, "pins-data", "us_counties.csv")))

  # .connect file should still exist
  expect_true(file.exists(file.path(
    temp_dir,
    "pins-data",
    "deployment.connect"
  )))

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})
