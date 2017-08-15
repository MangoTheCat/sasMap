#' Extract macro definitions from a string of SAS code
#'
#' @param sasVec Vector of SAS statements
#' @importFrom stringr str_extract_all
#' @importFrom stringr str_replace_all
#' @importFrom stringr str_trim
#' @return Vector of macro definitions
extractMacroDefs <- function(sasCode){
  
  # Split sasCode into statements
  sasVec <- splitIntoStatements(sasCode)
  
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
#' @param sasVec Vector of SAS statements
#' @importFrom stringr str_extract_all
#' @importFrom stringr str_replace_all
#' @return Vector of macro calls
extractMacroCalls <- function(sasCode, ignoreList = c("macro", "mend", "global", "let", "put", "if",
                                                      "do", "end", "else")){
  
  # Split sasCode into statements
  sasVec <- splitIntoStatements(sasCode)
  
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
#' @params sasVec Vector of SAS code
#' @importFrom stringr str_replace_all
extractProcs <-  function(sasVec){
  procs <- unlist(stringr::str_extract_all(sasVec, "^proc [a-zA-Z0-9]*"))
  stringr::str_replace_all(procs, "proc ", "")
  
}