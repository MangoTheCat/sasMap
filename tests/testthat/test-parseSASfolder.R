context("parseSASfolder")

test_that("returns a data.frame of parsed elements from a sas folder", {
  sasDir <- system.file('examples/SAScode', package='sasMap')
  sasCode_df <- parseSASfolder(sasDir, output="data.frame")
  
  expect_equal(class(sasCode_df), "data.frame")
  expect_equal(
    names(sasCode_df), 
    c("Script", "nLines", "Procs", "Data_step", "Macro_call", "Macro_define")
  )
  expect_equal(dim(sasCode_df), c(6L, 6L))
  expect_equal(sasCode_df$Script, structure(1:6, .Label = c("fun2", 
    "Init", "ModelCode", "Util1", "Util2", "MainAnalysis"), class = "factor"))

  expect_equal(sasCode_df$nLines, c(8L, 9L, 18L, 13L, 9L, 9L))
  expect_equal(sasCode_df$Procs, structure(c(1L, 1L, 2L, 3L, 4L, 
    5L), .Label = c("sql(1)", "logistic(1), print(2)", "freq(1), print(1)", 
    "contents(1), sql(1)", ""), class = "factor"))
  expect_equal(sasCode_df$Data_step, c(0L, 0L, 0L, 0L, 0L, 2L))
})

test_that("returns a list of parsed elements from a sas folder", {
  sasDir <- system.file('examples/SAScode', package='sasMap')
  sasCode_list <- parseSASfolder(sasDir, output="list")
  
  expect_equal(class(sasCode_list), "list")
  expect_equal(
    names(sasCode_list), 
    c("Script", "nLines", "Procs", "Data_step", "Macro_call", "Macro_define")
  )                                                                                                                                                                                
  expect_equal(sasCode_list$Macro_call, structure(list(fun2 = "util1", 
    init = c("fun2", "util1"), modelcode = "fun2", util1 = "fun1", 
    util2 = c("util1", "summary"), mainanalysis = c("init", "modelcode"
    )), .Names = c("fun2", "init", "modelcode", "util1", "util2", 
    "mainanalysis")))
  expect_equal(sasCode_list$Macro_define, structure(list(fun2 = "fun2", 
    init = "init", modelcode = "modelcode", util1 = "util1", 
    util2 = "util2", mainanalysis = character(0)), .Names = c("fun2", 
    "init", "modelcode", "util1", "util2", "mainanalysis")))                                              
})