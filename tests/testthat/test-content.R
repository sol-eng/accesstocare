test_that("Content metadata works",{
  apc <- atc_package_content()
  expect_length(
    capture.output(apc),
    17
  )
})

test_that("Content is copied", {
  temp_dir <- paste0(tempdir(), "/atc-coverage")
  
  atc_package_content_copy(target_folder = temp_dir, silent = TRUE)
  
  expect_length(
    dir(temp_dir),
    16
  )
  
  unlink(temp_dir, recursive = TRUE, force = TRUE)  
  
  expect_length(
    dir(temp_dir),
    0
  )
})


