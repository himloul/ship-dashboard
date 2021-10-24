library(testthat)
test_that("app.R")


test_that("as.vector() strips names", {
  x <- c(a = 1, b = 2)
  expect_equal(as.vector(x), c(1, 2))
})

usethis::use_test()
