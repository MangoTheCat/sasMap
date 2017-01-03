#' Parse the SAS script
#'
#' @param txt Path to a SAS script
#' @param funs functions to calculate stats
#' @param output data.frame or list
#' @return \code{list}.
#' @author Mango Solutions
#' @examples \dontrun{
#' library(sasMap)
#' sasDir <- system.file('examples/SAScode', package='sasMap')
#' parseSASscript(txt=file.path(sasDir, 'MainAnalysis.SAS'))
#' }
#' @importFrom readr read_file read_lines
#' @importFrom stringi stri_trim stri_count stri_extract_all stri_replace_all
#' @importFrom magrittr "%>%"
#' @export
parseSASscript <- function(txt,
                           funs = list("Script" = getScript_name,
                                       "nLines" = countLine,
                                       "Procs" = countProc,
                                       "Data_step" = countData_step,
                                       "Macro_call" = extractMacro_call,
                                       "Macro_define" = extractMacro_define
                           ),
                           output = "list",
                           ...) {
  
  
  stats <- lapply(funs, function(e) {e(txt)})
  names(stats) <- names(funs)    
  
  if(output == "data.frame") {
    if (length(stats$Procs)) {
      procString <- table(stats$Procs)
      procString <- paste(names(procString), "(", procString, ")", sep="", collapse=", ")
    } else procString <- ""    
    
    stats <- data.frame(
      Script = stats$Script,
      nLines = stats$nLines,
      Procs = procString,
      Data_step = stats$Data_step,
      Macro_call = paste(stats$Macro_call, sep = "", collapse = ", "), 
      Macro_define = paste(stats$Macro_define, sep = "", collapse = ", ")
    )
  }
  return(stats)
}

getScript_name <- function(txt, sasPattern ='\\.[Ss][Aa][Ss]$'){
  gsub(sasPattern, "", basename(txt), ignore.case=TRUE)
}

parseSAS <- function(txt) {
  
  # Read file 
  theCode <- readr::read_file(txt)
  
  # Make sure all are lowercase 
  theCode <- casefold(theCode) 
  
  # Remove comments of all styles including across lines
  theCode <- gsub(pattern = "/\\*.*?\\*/|\\*.*?;", replacement = "", x = theCode)
  if (stri_count(theCode , regex = "\r\n|\r|\n") + 1L) {theCode <- paste0(theCode, "\n")}
  # Remove white spaces
  theCode <- stri_trim(read_lines(theCode))
  # Drop empty lines
  theCode <- theCode [ theCode != "" ] 
  return(theCode)
  
}

countLine <- function(txt){
  theCode <- parseSAS(txt) 
  sum(theCode != "") # same as `length(theCode)`
}

# txt=file.path(sasDir, 'Macros/ModelCode.SAS')
countProc <- function(txt){
  theCode <- parseSAS(txt)
  theCode <- unlist(strsplit(theCode, ";")) # split strings by `;` and remove `;`
  
  # Extract proc lines
  idx <- NULL
  idx <- grep("^proc ", theCode)  
  
  proc <- strsplit(theCode[idx], " ")
  proc <- unlist(lapply(proc, `[[`, 2)) # Could be that the second element is null or invalid!!! A bug was captured.
  
  return(proc)
}

# txt = file.path(sasDir, 'MainAnalysis.SAS')
countData_step <- function(txt){
  theCode <- parseSAS(txt) 
  theCode <- unlist(strsplit(theCode, ";")) # split strings by `;` and remove `;`
  
  idx <- NULL
  idx <- grep("^data ", theCode)
  length(idx) # gsub(pattern = "^data\\s+", replacement = "", theCode[idx])
}

extractMacro_call <- function(txt, dropArg = NULL){
  theCode <- parseSAS(txt) 
  theCode <- unlist(strsplit(theCode, ";")) # split strings by `;` and remove `;`
  # extract all "%xxx"
  macro_call <- lapply(theCode, stringi::stri_extract_all, regex = "%[a-zA-Z0-9]*") %>% # [\\(\\s] 
    unlist() %>% 
    na.omit()
  # replace "%" with "", and remove "macro"/"mend"/""
  macro_call <- lapply(macro_call, stringi::stri_replace_all, regex = "%", replacement =  "") %>%
    unlist() %>% setdiff(c("macro", "mend", dropArg, ""))
  
  return(macro_call)
}

# txt=file.path(sasDir, 'Macros/ModelCode.SAS')
extractMacro_define <- function(txt, dropArg=NULL) {
  theCode <- parseSAS(txt) 
  theCode <- unlist(strsplit(theCode, ";")) # split strings by `;` and remove `;`

  macro_define <- lapply(theCode, stri_extract_all, regex = "%macro [a-zA-Z0-9]*") %>% # [\\(\\s] 
    unlist() %>% 
    na.omit()
  macro_define <- lapply(macro_define, stri_replace_all, regex = "%", replacement =  "") %>%
    unlist() %>% setdiff(c("macro", "mend", dropArg, ""))
  
    
  # Extract %macro lines
  idx <- NULL
  idx <- grep("\\s*%macro\\s+", theCode)
  
  # Replace %macro and spaces with non-space
  macro_define <- gsub(pattern = "\\s*%macro\\s+", replacement = "", x = theCode[idx]) # same as `stri_replace(theCode[idx], regex="\\s*%macro\\s+", "")`
  return(macro_define)  
}

