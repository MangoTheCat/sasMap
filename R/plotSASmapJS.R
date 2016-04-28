#' Plot interactive network of SAS scripts
#'
#' It creates basic force directed network graphics with depends on the networkD3 package.
#'
#' @param funData Parsed SAS code in data.frame
#' @param script Name of the script variable. Default is Script.
#' @param calls Name of the calls variable. Default is Calls.
#' @return \code{NULL}.
#' @author Mango Solutions
#' @examples \dontrun{
#' library(sasMap)
#' sasDir <- system.file('examples/SAScode', package='sasMap')
#' sasCode <- parseSASfolder(sasDir)
#' plotSASmapJS(funData=sasCode)
#' }
#' @importFrom networkD3 simpleNetwork
#' @export

plotSASmapJS <- function(funData, script="Script", calls="Calls"){

  if(missing(funData)) stop("Argument 'funData' is missing. It takes in the parsed sas code.")
  if (!all(c(script, calls) %in% names(funData))) warning("Arguments 'script' and 'calls' are missing. 'script' takes in the major scripts, and 'calls' are what has been called by this script.")

  funData[, script] <- as.character(funData[, script])
  funData[, calls] <- as.character(funData[, calls])

  lFun <- lapply(funData[, calls], function(x) {
    unlist(strsplit(gsub(" ", "", x), ","))
  })
  names(lFun) <- funData[, script]

  res <- list()
  for (i in seq_along(lFun)) {
    if(identical(lFun[[i]], character(0))) lFun[[i]] <- NA
    res[[i]] <- data.frame(src=names(lFun[i]), target=lFun[[i]])

  }

  networkData <- na.omit(do.call(rbind, res))

  simpleNetwork(networkData, textColour='#666', opacity=0.9, fontSize=11, zoom=TRUE)

}
