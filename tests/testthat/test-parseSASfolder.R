context("parseSASfolder")

test_that("returns parsed elements of a sas folder", {
  sasDir <- system.file('examples/SAScode', package='sasMap')
  sasCode_df <- parseSASfolder(sasDir, output="data.frame")
  sasCode_list <- parseSASfolder(sasDir, output="list")
  
  expect_equal(sasCode_df, structure(list(Script = structure(1:6, .Label = c("fun2", 
                                                                             "Init", "ModelCode", "Util1", "Util2", "MainAnalysis"), class = "factor"), 
                                          nLines = c(8L, 9L, 18L, 13L, 9L, 9L), Procs = structure(c(1L, 
                                                                                                    1L, 2L, 3L, 4L, 5L), .Label = c("sql(1)", "logistic(1), print(2)", 
                                                                                                                                    "freq(1), print(1)", "contents(1), sql(1)", ""), class = "factor"), 
                                          Data_step = c(0L, 0L, 0L, 0L, 0L, 2L), Macro_call = structure(1:6, .Label = c("util1", 
                                                                                                                        "fun2, util1", "fun2", "fun1", "util1, summary", "init, modelcode"
                                          ), class = "factor"), Macro_define = structure(1:6, .Label = c("fun2", 
                                                                                                         "init", "modelcode", "util1", "util2", ""), class = "factor")), .Names = c("Script", 
                                                                                                                                                                                    "nLines", "Procs", "Data_step", "Macro_call", "Macro_define"), row.names = c("fun2", 
                                                                                                                                                                                                                                                                 "init", "modelcode", "util1", "util2", "mainanalysis"), class = "data.frame"))
  
  expect_equal(sasCode_list, structure(list(Script = structure(list(
    fun2 = "fun2", init = "Init", modelcode = "ModelCode", util1 = "Util1", 
    util2 = "Util2", mainanalysis = "MainAnalysis"), .Names = c("fun2", 
                                                                "init", "modelcode", "util1", "util2", "mainanalysis")), nLines = structure(list(
                                                                  fun2 = 8L, init = 9L, modelcode = 18L, util1 = 13L, util2 = 9L, 
                                                                  mainanalysis = 9L), .Names = c("fun2", "init", "modelcode", 
                                                                                                 "util1", "util2", "mainanalysis")), Procs = structure(list(fun2 = "sql", 
                                                                                                                                                            init = "sql", modelcode = c("logistic", "print", "print"), 
                                                                                                                                                            util1 = c("freq", "print"), util2 = c("contents", "sql"), 
                                                                                                                                                            mainanalysis = NULL), .Names = c("fun2", "init", "modelcode", 
                                                                                                                                                                                             "util1", "util2", "mainanalysis")), Data_step = structure(list(
                                                                                                                                                                                               fun2 = 0L, init = 0L, modelcode = 0L, util1 = 0L, util2 = 0L, 
                                                                                                                                                                                               mainanalysis = 2L), .Names = c("fun2", "init", "modelcode", 
                                                                                                                                                                                                                              "util1", "util2", "mainanalysis")), Macro_call = structure(list(
                                                                                                                                                                                                                                fun2 = "util1", init = c("fun2", "util1"), modelcode = "fun2", 
                                                                                                                                                                                                                                util1 = "fun1", util2 = c("util1", "summary"), mainanalysis = c("init", 
                                                                                                                                                                                                                                                                                                "modelcode")), .Names = c("fun2", "init", "modelcode", "util1", 
                                                                                                                                                                                                                                                                                                                          "util2", "mainanalysis")), Macro_define = structure(list(fun2 = "fun2", 
                                                                                                                                                                                                                                                                                                                                                                                   init = "init", modelcode = "modelcode", util1 = "util1", 
                                                                                                                                                                                                                                                                                                                                                                                   util2 = "util2", mainanalysis = character(0)), .Names = c("fun2", 
                                                                                                                                                                                                                                                                                                                                                                                                                                             "init", "modelcode", "util1", "util2", "mainanalysis"))), .Names = c("Script", 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  "nLines", "Procs", "Data_step", "Macro_call", "Macro_define")))

})