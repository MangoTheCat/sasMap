#' Load SAS Code in
#'
#' @param sasPath SAS file location
#' @importFrom readr read_file
#' @importFrom stringi stri_trans_general
#' @return Character string containing contents of the file
#' @export
loadSAS <- function(sasPath){
  
  # Read in SAS code
  rawFile <- readr::read_file(sasPath)
  
  # Ensure correct encoding
  rawFile <- stringi::stri_trans_general(rawFile, "latin-ascii")
  
  # Divide up
  sasCode <- splitIntoStatements(rawFile)
  
  # Put all in lower case
  sasCode <- tolower(sasCode)
  
  # Paste back together
  sasCode <- paste(sasCode, collapse = "")
  
  sasCode
}

#' Split SAS code into statements
#'
#' @param sasCode Character string containing SAS code
#' @importFrom stringr str_split
splitIntoStatements <- function(sasCode){
  unlist(stringr::str_split(sasCode, "(?<=[;])"))
}

