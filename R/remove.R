#' Remove multiline comments from SAS code
#'
#' @param sasCode Character string containing SAS code
#' @importFrom stringr str_replace_all
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
removeSingleLineComments <- function(sasVec){
  sasVec[!stringr::str_detect(sasVec, "^[:space:]*\\*")]
}


#' Remove whitespace characters from SAS code
#'
#' @param sasCode Character string containing SAS code
#' @importFrom stringr str_replace_all
removeWhitespaceCharacters <- function(sasCode){
  sasCode <- stringr::str_replace_all(sasCode, "^ *?", "")
  stringr::str_replace_all(sasCode, "[\r\n\\\r\\\n\t]", " ")
  
}