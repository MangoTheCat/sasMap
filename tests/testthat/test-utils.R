context("utils")

s <- system.file('examples/SAScode/MainAnalysis.SAS', package='sasMap')

test_that("Loads a SAS script", {
  
  expectedCode <- "/* just samples for demoing of sasmap's feature */\r\n/* the code here may even not runnable under sas */\r\n\r\n\r\n%init;\r\n\r\ndata mylib.iris;             \r\n    set sashelp.iris;        \r\nrun;                \r\n        \r\ndata mylib.iris;             \r\n    set  mylib.iris;         \r\n    petallength = 0;         \r\nrun; \r\n\r\n%modelcode;"
  
  expect_equal(loadSAS(s), expectedCode)
  
})

test_that("Divides a SAS script into statements", {
  
  expectedCode <- c("/* just samples for demoing of sasmap's feature */\r\n/* the code here may even not runnable under sas */\r\n\r\n\r\n%init;", 
                    "\r\n\r\ndata mylib.iris;", "             \r\n    set sashelp.iris;", 
                    "        \r\nrun;", "                \r\n        \r\ndata mylib.iris;", 
                    "             \r\n    set  mylib.iris;", "         \r\n    petallength = 0;", 
                    "         \r\nrun;", " \r\n\r\n%modelcode;", "")
    
 
  
  expect_equal(splitIntoStatements(loadSAS(s)), expectedCode)
  
})






