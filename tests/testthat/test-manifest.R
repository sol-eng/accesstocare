test_that("Manifests are being written to content folder", {
  temp_dir <- paste0(tempdir(), "/atc-manifest")
  
  atc_package_content_copy(target_folder = temp_dir)
  
  mnf <- atc_write_all_manifests(temp_dir)
  
  expect_length(
    nrow(mnf),
    16
  )
  
  unlink(temp_dir, recursive = TRUE, force = TRUE)  
  
  expect_length(
    dir(temp_dir),
    0
  )  
})
