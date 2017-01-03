context("renderNetwork")

test_that("renders a network", {
  sasDir <- system.file('examples/SAScode', package='sasMap')
  net <- renderNetwork(sasDir)
  expect_equal(class(net), "network")
  
})