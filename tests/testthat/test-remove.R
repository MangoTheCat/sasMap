context("remove")

s <- system.file('examples/SAScode/Macros/Util2.SAS', package='sasMap')

sasCode <- loadSAS(s)

test_that("Removes multiline comments", {
  
  withoutMulti <- "\r\n* this is a comment ;\r\n%macro util2;\r"
  
  commentFree <- removeMultilineComments(sasCode)
  commentFreeTrimmed <- substr(commentFree, 1, 39)
  
  expect_equal(commentFreeTrimmed, withoutMulti)
  
})

test_that("Removes all comments", {
  
  withoutAny <- "\r\n%macro util2;\r\n\r\n    %util1;"
  
  commentFree <- removeAllComments(sasCode)
  commentFreeTrimmed <- substr(commentFree, 1, 30)
  
  expect_equal(commentFreeTrimmed, withoutAny)
  
})

test_that("Removes all whitespace", {
  
  whiteRemoved <- "/* the second utility */  * th"
  
  noWhite <- removeWhitespaceCharacters(sasCode)
  noWhiteTrimmed <- substr(noWhite, 1, 30)
  
  expect_equal(noWhiteTrimmed, whiteRemoved)
  
})

