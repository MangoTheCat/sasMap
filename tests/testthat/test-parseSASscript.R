context("parseSASscript")

test_that("returns parsed elements of a sas script", {
  sasDir <- system.file('examples/SAScode', package='sasMap')
  res_df <- parseSASscript(txt=file.path(sasDir, 'MainAnalysis.SAS'), output="data.frame")
  res_list <- parseSASscript(txt=file.path(sasDir, 'MainAnalysis.SAS'), output="list")
  
  expect_equal(class(res_df), "data.frame")
  expect_equal(res_df$Script, structure(1L, .Label = "MainAnalysis", class = "factor"))
  expect_equal(res_df$nLines, 9L)
  expect_equal(res_df$Procs, structure(1L, .Label = "", class = "factor"))
  expect_equal(res_df$Data_step, 2L)
  expect_equal(res_df$Macro_call, structure(1L, .Label = "init, modelcode", class = "factor"))
  expect_equal(res_df$Macro_define, structure(1L, .Label = "", class = "factor"))
  
  expect_equal(class(res_list), "list")
  expect_equal(res_list, structure(list(Script = "MainAnalysis", 
                                        nLines = 9L, Procs = NULL, Data_step = 2L, Macro_call = c("init", 
                                                                                                  "modelcode"), Macro_define = character(0)), .Names = c("Script", 
                                                                                                                                                         "nLines", "Procs", "Data_step", "Macro_call", "Macro_define")))
  
})
