test_that("create_content copies single content", {
  temp_dir <- paste0(tempdir(), "/create-single")

  create_content(
    target = temp_dir,
    content = "app-r",
    silent = TRUE
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
    silent = TRUE
  )

  # Should have 12 inst/content folders + r-plot + r-htmlwidgets + pins-data (dynamically generated) = 15 total
  expect_gte(length(dir(temp_dir)), 15)

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})

test_that("create_content respects force=FALSE", {
  temp_dir <- paste0(tempdir(), "/create-force")

  # Create first time
  create_content(
    target = temp_dir,
    content = "app-r",
    silent = TRUE
  )

  # Try to create again without force
  expect_warning(
    create_content(
      target = temp_dir,
      content = "app-r",
      silent = FALSE
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
    silent = TRUE
  )

  # Create again with force
  create_content(
    target = temp_dir,
    content = "app-r",
    force = TRUE,
    silent = TRUE
  )

  expect_true(dir.exists(file.path(temp_dir, "app-r")))

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})

test_that("create_content generates r-plot content", {
  temp_dir <- paste0(tempdir(), "/create-r-plot")

  create_content(
    target = temp_dir,
    content = "r-plot",
    silent = TRUE
  )

  expect_true(dir.exists(file.path(temp_dir, "r-plot")))
  expect_true(file.exists(file.path(temp_dir, "r-plot", "map.png")))
  expect_true(file.exists(file.path(temp_dir, "r-plot", "map.html")))

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})

test_that("create_content generates r-htmlwidgets content", {
  temp_dir <- paste0(tempdir(), "/create-r-htmlwidgets")

  create_content(
    target = temp_dir,
    content = "r-htmlwidgets",
    silent = TRUE
  )

  expect_true(dir.exists(file.path(temp_dir, "r-htmlwidgets")))
  expect_true(file.exists(file.path(temp_dir, "r-htmlwidgets", "map.html")))

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})

test_that("create_content generates pins-data content", {
  temp_dir <- paste0(tempdir(), "/create-pins-data")

  create_content(
    target = temp_dir,
    content = "pins-data",
    silent = TRUE
  )

  expect_true(dir.exists(file.path(temp_dir, "pins-data")))
  expect_true(file.exists(file.path(temp_dir, "pins-data", "us_counties.csv")))

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})

test_that("create_content exports parquet for app-python", {
  skip_if_not_installed("arrow")

  temp_dir <- paste0(tempdir(), "/create-app-python")

  create_content(
    target = temp_dir,
    content = "app-python",
    silent = TRUE
  )

  expect_true(dir.exists(file.path(temp_dir, "app-python")))
  expect_true(dir.exists(file.path(temp_dir, "app-python", "data")))
  expect_true(file.exists(file.path(temp_dir, "app-python", "data", "us_counties.parquet")))

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})

test_that("create_content exports parquet for dashboard-python", {
  skip_if_not_installed("arrow")

  temp_dir <- paste0(tempdir(), "/create-dashboard-python")

  create_content(
    target = temp_dir,
    content = "dashboard-python",
    silent = TRUE
  )

  expect_true(dir.exists(file.path(temp_dir, "dashboard-python")))
  expect_true(dir.exists(file.path(temp_dir, "dashboard-python", "data")))
  expect_true(file.exists(file.path(temp_dir, "dashboard-python", "data", "us_counties.parquet")))
  expect_true(file.exists(file.path(temp_dir, "dashboard-python", "data", "us_states.parquet")))
  expect_true(file.exists(file.path(temp_dir, "dashboard-python", "data", "us_hex_positions.parquet")))
  expect_true(file.exists(file.path(temp_dir, "dashboard-python", "data", "us_atc_county_polygons.parquet")))
  expect_true(file.exists(file.path(temp_dir, "dashboard-python", "data", "us_large_cities.parquet")))
  expect_true(file.exists(file.path(temp_dir, "dashboard-python", "access-to-care.qmd")))

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})

test_that("create_content exports parquet for api-python", {
  skip_if_not_installed("arrow")

  temp_dir <- paste0(tempdir(), "/create-api-python")

  create_content(
    target = temp_dir,
    content = "api-python",
    silent = TRUE
  )

  expect_true(dir.exists(file.path(temp_dir, "api-python")))
  expect_true(dir.exists(file.path(temp_dir, "api-python", "data")))
  expect_true(file.exists(file.path(temp_dir, "api-python", "data", "us_counties.parquet")))
  expect_true(file.exists(file.path(temp_dir, "api-python", "data", "us_states.parquet")))
  expect_true(file.exists(file.path(temp_dir, "api-python", "main.py")))
  expect_true(file.exists(file.path(temp_dir, "api-python", ".gitignore")))

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
    silent = TRUE
  )

  # Add a .connect file
  writeLines("connect data", file.path(temp_dir, "pins-data", "deployment.connect"))

  # Force overwrite
  create_content(
    target = temp_dir,
    content = "pins-data",
    force = TRUE,
    silent = TRUE
  )

  # Content should be recreated
  expect_true(file.exists(file.path(temp_dir, "pins-data", "us_counties.csv")))

  # .connect file should still exist
  expect_true(file.exists(file.path(temp_dir, "pins-data", "deployment.connect")))

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})
