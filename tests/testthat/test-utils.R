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

test_that("TOC works", {
  
  readme_rmd <- paste0(tempdir(), "readme.Rmd") 
  
  writeLines("---\n output:github_document\n---\n# header1\n## header 2\n### header 3", readme_rmd)
  
  expect_output(
    toc(readme_rmd), 
    "- "
  )
})
