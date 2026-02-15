test_that("create_content copies single content", {
  temp_dir <- paste0(tempdir(), "/create-single")

  create_content(
    target = temp_dir,
    content = "shiny",
    silent = TRUE
  )

  expect_true(dir.exists(file.path(temp_dir, "shiny")))
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

  # Should have 12 inst/content folders + plot + htmlwidgets
  expect_gte(length(dir(temp_dir)), 11)

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})

test_that("create_content respects force=FALSE", {
  temp_dir <- paste0(tempdir(), "/create-force")

  # Create first time
  create_content(
    target = temp_dir,
    content = "shiny",
    silent = TRUE
  )

  # Try to create again without force
  expect_warning(
    create_content(
      target = temp_dir,
      content = "shiny",
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
    content = "shiny",
    silent = TRUE
  )

  # Create again with force
  create_content(
    target = temp_dir,
    content = "shiny",
    force = TRUE,
    silent = TRUE
  )

  expect_true(dir.exists(file.path(temp_dir, "shiny")))

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})

test_that("create_content generates plot content", {
  temp_dir <- paste0(tempdir(), "/create-plot")

  create_content(
    target = temp_dir,
    content = "plot",
    silent = TRUE
  )

  expect_true(dir.exists(file.path(temp_dir, "plot")))
  expect_true(file.exists(file.path(temp_dir, "plot", "map.png")))
  expect_true(file.exists(file.path(temp_dir, "plot", "map.html")))

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})

test_that("create_content generates htmlwidgets content", {
  temp_dir <- paste0(tempdir(), "/create-htmlwidgets")

  create_content(
    target = temp_dir,
    content = "htmlwidgets",
    silent = TRUE
  )

  expect_true(dir.exists(file.path(temp_dir, "htmlwidgets")))
  expect_true(file.exists(file.path(temp_dir, "htmlwidgets", "map.html")))

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})

test_that("create_content exports parquet for dash", {
  skip_if_not_installed("arrow")

  temp_dir <- paste0(tempdir(), "/create-dash")

  create_content(
    target = temp_dir,
    content = "dash",
    silent = TRUE
  )

  expect_true(dir.exists(file.path(temp_dir, "dash")))
  expect_true(dir.exists(file.path(temp_dir, "dash", "data")))
  expect_true(file.exists(file.path(temp_dir, "dash", "data", "us_counties.parquet")))

  unlink(temp_dir, recursive = TRUE, force = TRUE)
})
