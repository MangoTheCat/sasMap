#' Remove multiline comments from SAS code
#'
#' @param sasCode Character string containing SAS code
#' @importFrom stringr str_replace_all
#' @export
#' @examples 
#' sasFile <- system.file('examples/SAScode/Macros/Util2.SAS', package='sasMap')
#' sasCode <- loadSAS(sasFile)
#' removeMultilineComments(sasCode)
removeMultilineComments <- function(sasCode){
  
  # (\\/\\*) = match "/*"
  # [[:print:][:space:]] = match any printable or space characters
  # *? = zero or more times, non-greedy
  # (\\*\\/) = match "*/"
  sasCode <- stringr::str_replace_all(sasCode, "(\\/\\*)[[:print:][:space:]]*?(\\*\\/)", "")
  sasCode
}

#' Remove single line comments from a vector of SAS statements
#'
#' Finds and removes all lines starting with "*"
#'
#' @param sasVec Vector of SAS code
#' @importFrom stringr str_detect
#' @export
#' @examples 
#' sasFile <- system.file('examples/SAScode/Macros/Util2.SAS', package='sasMap')
#' sasCode <- loadSAS(sasFile)
#' removeAllComments(sasCode)
removeSingleLineComments <- function(sasVec){
  sasVec[!stringr::str_detect(sasVec, "^[:space:]*\\*")]
}


#' Remove single line comments from a character string containing SAS code
#'
#' This version of this function removes all comments.
#'
#' @param sasCode Character string containing SAS code
#' @export
#' @return Character string of SAS code with comments removed
removeAllComments <- function(sasCode){
  # Remove multiline comments
  sasCode <- removeMultilineComments(sasCode)
  
  # Split SAS code into statements
  sasVec <- splitIntoStatements(sasCode)
  
  # Remove all single line comments
  sasVec <- removeSingleLineComments(sasVec)
  
  sasVec <- removeMultilineComments(sasVec)
  
  # Reassemble SAS file
  sasCode <- paste(sasVec, collapse="")
  
  sasCode
  
}


#' Remove whitespace characters from SAS code
#'
#' @param sasCode Character string containing SAS code
#' @importFrom stringr str_replace_all
#' @importFrom stringr str_trim
#' @export
#' @examples 
#' sasFile <- system.file('examples/SAScode/Macros/Util2.SAS', package='sasMap')
#' sasCode <- loadSAS(sasFile)
#' removeWhitespaceCharacters(sasCode)
removeWhitespaceCharacters <- function(sasCode){
  sasCode <- stringr::str_replace_all(sasCode, "^ *?", "")
  sasCode <- stringr::str_replace_all(sasCode, "[\r\n\\\r\\\n\t]", " ")
  stringr::str_trim(sasCode)
  
}