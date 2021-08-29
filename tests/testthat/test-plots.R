test_that("Hospitals plots work", {
  expect_s3_class(
    atc_plot_hospitals(show_model_results = TRUE),
    "ggplot"
  )
})

test_that("US map plots work", {
  expect_s3_class(
    atc_plot_us_map("population"),
    "ggplot"
  )
  expect_s3_class(
    atc_plot_us_map("hospitals"),
    "ggplot"
  )
  expect_s3_class(
    atc_plot_us_map("above"),
    "ggplot"
  )
  expect_s3_class(
    atc_plot_us_map("below"),
    "ggplot"
  )
})

test_that("State map plots work", {
  expect_s3_class(
    atc_plot_state_map(variable = "model"),
    "ggplot"
  )
  expect_s3_class(
    atc_plot_state_map("All US", variable = "population"),
    "ggplot"
  )
  expect_s3_class(
    atc_plot_state_map(variable = "hospitals"),
    "ggplot"
  )
})