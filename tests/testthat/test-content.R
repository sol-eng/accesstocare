test_that("Content metadata works", {
  apc <- atc_package_content()
  expect_length(
    capture.output(apc),
    17
  )
})

test_that("Single content folder is copied", {
  temp_dir <- paste0(tempdir(), "/atc-single")

  atc_copy_content(
    target_folder = temp_dir,
    silent = TRUE,
    content_no = 1
  )

  expect_length(dir(temp_dir), 1)

  unlink(temp_dir, recursive = TRUE, force = TRUE)

  expect_length(dir(temp_dir), 0)
})


test_that("All content folder is copied", {
  temp_dir <- paste0(tempdir(), "/atc-all")

  atc_copy_all_content(
    target_folder = temp_dir,
    silent = TRUE
  )

  expect_length(dir(temp_dir), 16)

  unlink(temp_dir, recursive = TRUE, force = TRUE)

  expect_length(dir(temp_dir), 0)
})
