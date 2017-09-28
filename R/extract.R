#' Extract macro definitions from a string of SAS code
#'
#' @param sasCode SAS code
#' @importFrom stringr str_extract_all
#' @importFrom stringr str_replace_all
#' @importFrom stringr str_trim
#' @return Vector of macro definitions
#' @export
#' @examples 
#' sasFile <- system.file('examples/SAScode/Macros/Util1.SAS', package='sasMap')
#' sasCode <- loadSAS(sasFile)
#' extractMacroDefs(sasCode)
extractMacroDefs <- function(sasCode){
  
  # Remove comments from code
  sasCode <- removeAllComments(sasCode)
  
  # Split sasCode into statements
  sasVec <- splitIntoStatements(sasCode)
  
  # Remove whitespace
  sasVec <- removeWhitespaceCharacters(sasVec)
  
  # Extract all statements beginning with %macro
  macroDefs <- unlist(stringr::str_extract_all(sasVec, "^%macro .*"))
  
  # Remove semi-colon and %
  macroDefs <- stringr::str_replace_all(macroDefs, "[;%]", "")
  
  # Remove any brackets
  macroDefs <- stringr::str_replace_all(macroDefs, "\\(.*\\).*", "")
  
  # Remove the word 'macro'
  macroDefs <- stringr::str_replace_all(macroDefs, "macro", "")
  
  # Trim any whitespace
  macroDefs <- stringr::str_trim(macroDefs)
  
  # Return only non-empty strings
  macroDefs[macroDefs!=""]
  
}


#' Extract macro calls from a string of SAS code
#'
#' @param sasCode SAS code
#' @param ignoreList Macro calls to ignore
#' @importFrom stringr str_extract_all
#' @importFrom stringr str_replace_all
#' @export
#' @return Vector of macro calls
#' @examples 
#' sasFile <- system.file('examples/SAScode/Macros/Util1.SAS', package='sasMap')
#' sasCode <- loadSAS(sasFile)
#' extractMacroCalls(sasCode)
extractMacroCalls <- function(sasCode, ignoreList = c("macro", "mend", "global", "let", "put", "if",
                                                      "do", "end", "else", "sysrput", "sysfunc", "symput")){
  
  # Split sasCode into statements
  sasVec <- splitIntoStatements(sasCode)
  
  # Remove whitespace
  sasVec <- removeWhitespaceCharacters(sasVec)
  
  # Extract all statements beginning with %
  macroCalls <- unlist(stringr::str_extract_all(sasVec, "^%[[:alnum:][:punct:]]*"))
  
  # Remove all % and ;
  macroCalls <- stringr::str_replace_all(macroCalls, "[;%]", "")
  
  # Remove any brackets and subsequent characters
  macroCalls <- stringr::str_replace_all(macroCalls, "\\(.*", "")
  
  macroCalls <- macroCalls[!macroCalls %in% ignoreList]
  
  # Return only non-empty strings
  macroCalls[macroCalls!=""]
  
}

#' Extract  procs from a vector of SAS code
#'
#' @param sasCode SAS code
#' @importFrom stringr str_replace_all
#' @export
#' @examples 
#' sasFile <- system.file('examples/SAScode/Macros/Util1.SAS', package='sasMap')
#' sasCode <- loadSAS(sasFile)
#' extractProcs(sasCode)
extractProcs <-  function(sasCode){
  
  # Split sasCode into statements
  sasVec <- splitIntoStatements(sasCode)
  
  # Remove whitespace
  sasVec <- removeWhitespaceCharacters(sasVec)
 
  procs <- unlist(stringr::str_extract_all(sasVec, "^proc [a-zA-Z0-9]*"))
  stringr::str_replace_all(procs, "proc ", "")
  
}
