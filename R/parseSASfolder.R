#' Extract summary information of data steps and proc calls by parsing a SAS folder.
#'
#' @param dirPath Path to the folder that holds all SAS scripts
#' @param sasPattern Pattern of sas files
#' @param output Output should be data.frame or list? Default is data.frame.
#' @return \code{data.frame} or \code{list}.
#' @author Mango Solutions
#' @examples \dontrun{
#' library(sasMap)
#' sasDir <- system.file('examples/SAScode', package='sasMap')
#' sasCode <- parseSASfolder(sasDir)
#' ##parseSASfolder("C:\\Projects\\sas2r\\Source code dump\\CORD\\Formats")
#' parseSASfolder("C:\\Projects\\sas2r\\Source code dump\\CORD\\Macros")
#' ##parseSASfolder("C:\\Projects\\sas2r\\Source code dump\\CORD\\StoredProcesses")
#' write.csv(sasCode, 'sasCode.csv', row.names = FALSE)
#' }
#' @export
#' @importFrom purrr transpose
parseSASfolder <- function(dirPath, sasPattern ='\\.[Ss][Aa][Ss]$', output = "data.frame"){
  sasFiles <- list.files(dirPath, recursive=TRUE, pattern=sasPattern, full.names=TRUE)
  
  out <- list()
  for(fn in sasFiles) { 
    out[[ casefold(sub(sasPattern,'',basename(fn))) ]] <- parseSASscript(fn, output = output)
  } # gsub(sasPattern, "", basename(fn), ignore.case=TRUE) - row name is original
    # casefold(sub(sasPattern,'',basename(fn))) - row name is lowercase
    # Name of the list element should be full path, otherwise 
    # file of the same name live in different folder will be overwritten! 

  out <- switch (output,
      data.frame = do.call(rbind, out),
      list = purrr::transpose(out)
  )
  
  return(out)
}
