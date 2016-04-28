#' Parse the SAS script
#'
#' @param txt Path to a SAS script
#' @param allFiles Character vector indicating all sas scripts
#' @param output  Output should be data.frame or list? Default is data.frame.
#' @return \code{data.frame} or \code{character}.
#' @author Mango Solutions
#' @examples \dontrun{
#' library(sasMap)
#' sasDir <- system.file('examples/SAScode', package='sasMap')
#' parseSASscript(txt=file.path(sasDir, 'MainAnalysis.SAS'))
#' }
#' @export
parseSASscript <- function(txt,
                           allFiles = sub('\\.sas$', '', casefold(basename(list.files(pattern='\\.[Ss][Aa][Ss]$', recursive=TRUE)))),
                           output="data.frame") {

  trim <- function(x) gsub("^\\s+|", "", x)
  theCode <- casefold(trim(scan(txt, what = character(), sep="\n", quiet = TRUE)))
  theCode <- theCode [ theCode != "" ]
  if (length(grep("^/\\*", theCode)) > 0) theCode <- theCode [ -grep("^/\\*", theCode) ]  # Remove comment lines styling as /**/
  if (length(grep("^\\*", theCode)) > 0) theCode <- theCode [ -grep("^\\*", theCode) ] # Remove comment lines styling as *;
  dataLines <- length(grep("^data ", theCode)) # TODO: Aby chances the lines starting with data are not data steps?
  whichCall <- sapply(paste0("%", allFiles, "[;(]+"), function(txt, code) length(grep(txt, code)), code= theCode)
  callFuns <- if (sum(whichCall)) paste0(allFiles[whichCall > 0], collapse=",") else ""
  procLines <- grep("^proc", theCode)

  #allProcs <- c()
  procTab <- NULL
  if (length(procLines)) { # there are procs!
    procCode <- gsub(";", " ", substring(theCode [ procLines ], 6))
    procCode <- substring(procCode, 1, regexpr(" ", procCode)-1)
    #assign("allProcs", c(get("allProcs", pos = 1), procCode), pos = 1)
    procTab <- table(procCode)
    procString <- paste(names(procTab), "(", procTab, ")", sep="", collapse=", ")
  } else procString <- ""

  includeLines <- grep("^\\%include", theCode)
  if (length(includeLines)) {
    includeCode <- theCode[includeLines]

	includeCode <- gsub("%include ", "", includeCode)
	includeCode <- gsub("\\;", "", includeCode)
	includeCode <- paste(includeCode, sep="", collapse=", ")
	includeString <- noquote(includeCode)

  } else includeString <- ""

  if (output == "list") {
    if (!is.null(procTab)) {
      res <- sprintf('[proc]%s', names(procTab))
    } else {
      res <- character(0)
    }
    res <- c(res, allFiles[whichCall > 0])
  } else {
    res <- data.frame(Script = casefold(gsub(".sas", "", basename(txt), ignore.case=TRUE)),
                      nLines = length(theCode),
                      Procs = procString,
                      DataSteps = dataLines,
                      Calls = callFuns)
    res$`%include` <- includeString
  }

  return(res)

}
