#' Count number of data steps in a SAS file
#'
#' @param sasCode Character string containing SAS code
#' @importFrom stringr str_trim
#' @importFrom stringr str_count
#' @export
#' @examples 
#' sasFile <- system.file('examples/SAScode/MainAnalysis.SAS', package='sasMap')
#' sasCode <- loadSAS(sasFile)
#' countDataSteps(sasCode)
countDataSteps <- function(sasCode){
  
  sasCode <- removeAllComments(sasCode)
  
  sasCode <- removeWhitespaceCharacters(sasCode)
  
  # Create a vector of SAS statements
  sasVec <- splitIntoStatements(sasCode)
  
  sasVec <- stringr::str_trim(sasVec)
  
  sum(stringr::str_count(sasVec, "^data "))
  
}

#' Count number of proc steps in a SAS file
#'
#' @param sasCode Character string containing SAS code
#' @importFrom stringr str_trim
#' @importFrom stringr str_count
#' @export
#' @examples 
#' sasFile <- system.file('examples/SAScode/MainAnalysis.SAS', package='sasMap')
#' sasCode <- loadSAS(sasFile)
#' countProcSteps(sasCode)
countProcSteps <- function(sasCode){
  
  sasCode <- removeAllComments(sasCode)
  
  sasCode <- removeWhitespaceCharacters(sasCode)
  
  # Create a vector of SAS statements
  sasVec <- splitIntoStatements(sasCode)
  
  # Trim remaining whitespace
  sasVec <- stringr::str_trim(sasVec)
  
  # Count all statements which begin with proc
  sum(stringr::str_count(sasVec, "^proc "))
  
}

#' Count lines in a SAS file
#'
#' @param sasCode Character string containing SAS code
#' @importFrom stringr str_count
#' @export
#' @examples 
#' sasFile <- system.file('examples/SAScode/MainAnalysis.SAS', package='sasMap')
#' sasCode <- loadSAS(sasFile)
#' countLines(sasCode)
countLines <- function(sasCode){
  
  sum(stringr::str_count(sasCode, "\n"))
  
}

#' Count statements in a SAS file
#'
#' @param sasCode Character string containing SAS code
#' @export
#' @examples
#' sasFile <- system.file('examples/SAScode/MainAnalysis.SAS', package='sasMap')
#' sasCode <- loadSAS(sasFile)
#' countStatements(sasCode)
countStatements <- function(sasCode){
  
  sasCode <- splitIntoStatements(sasCode)
  
  length(sasCode)
  
}