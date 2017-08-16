#' Summarise a SAS script
#' @param sasPath Path to SAS script
#' @export
#' @examples 
#' sasPath <- system.file('examples/SAScode/Macros/fun2.SAS', package='sasMap')
#' summariseSASScript(sasPath)
summariseSASScript <- function(sasPath){
  
  sasCode <- loadSAS(sasPath)
  
  list(name = basename(sasPath),
             lines = countLines(sasCode),
             procs = extractProcs(sasCode),
             datasteps = countDataSteps(sasCode),
       macroCalls = extractMacroCalls(sasCode),
       macroDefs = extractMacroDefs(sasCode))
  
}