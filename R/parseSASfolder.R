##' Extract summary information of data steps and proc calls by parsing a SAS folder.
##'
##' @param sasDir Path to the folder that holds all SAS scripts
##' @param output Output should be data.frame or list? Default is data.frame.
##' @return \code{data.frame} or \code{list}.
##' @author Mango Solutions
##' @examples \dontrun{
##' library(sasMap)
##' sasDir <- system.file('examples/SAScode', package='sasMap')
##' sasCode <- parseSASfolder(sasDir)
##' write.csv(sasCode, 'sasCode.csv', row.names = FALSE)
##' }
##' @export
#parseSASfolder <- function(sasDir, output="data.frame") {
#
#  outpath <- getwd()
#  setwd(sasDir)
#  on.exit(setwd(outpath))
#
#  sasPattern <- '\\.[Ss][Aa][Ss]$'
#  sasFiles <- list.files(sasDir, recursive=TRUE, pattern=sasPattern, full.names=TRUE)
#
#  if (output=="list") {
#	  sasCode <- list()
#      for(fn in sasFiles) {
#          sasCode[[ casefold(sub(sasPattern, '' ,basename(fn))) ]] <- parseSASscript(fn, output="list")
#      }
#
#  } else {
#    sasCode <- do.call("rbind", lapply(sasFiles, parseSASscript))
#  }
#
#
#  return(sasCode)
#
#}
#' @importFrom purrr transpose
parseSASfolder <- function(sasDir, sasPattern ='\\.[Ss][Aa][Ss]$', output = "list"){
  sasFiles <- list.files(sasDir, recursive=TRUE, pattern=sasPattern, full.names=TRUE)
  
  out <- list()
  for(fn in sasFiles) {
    out[[ casefold(sub(sasPattern,'',basename(fn))) ]] <- parseSASscript(fn, output = output)
  }
  
  if(output == "data.frame") {
    out <- do.call(rbind, out)
  } else out <-  purrr::transpose(out)

  return(out)
}
