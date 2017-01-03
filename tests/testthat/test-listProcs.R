context("listProcs")

test_that("lists procs", {
  sasDir <- system.file('examples/SAScode', package='sasMap')
  res <- listProcs(sasDir)
  
  expect_equal(res$Proc, structure(c(4L, 5L, 1L, 2L, 3L), 
                                   .Label = c("contents", "freq", "logistic", "print", "sql"), class = "factor"))
  expect_equal(res$N, c(3, 3, 1, 1, 1))
})