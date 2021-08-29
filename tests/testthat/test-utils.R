test_that("Format functions return expected results", {
  expect_equal(
    format_currency(1234),
    "$1K"
  )
  expect_equal(
    format_currency(1234, 2),
    "$1.23K"    
  )
  expect_equal(
    format_currency(1234567),
    "$1M"
  )
  expect_equal(
    format_currency(1234567890),
    "$1B"
  )
  expect_equal(
    format_currency(123),
    "$123"
  )
})