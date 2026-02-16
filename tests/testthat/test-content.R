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

  # Should have 12 inst/content folders + r-plot + r-htmlwidgets (dynamically generated) = 14 total
  expect_gte(length(dir(temp_dir)), 14)

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
