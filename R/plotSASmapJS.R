#' Plot interactive network of SAS scripts
#'
#' It creates basic force directed network graphics with depends on the networkD3 package.
#'
#' @param funData Parsed SAS code from multiple scripts
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
plotSASmapJS <- function(funData){
  
  if(missing(funData)) stop("Argument 'funData' is missing. It takes in the parsed sas code.")
  if(length(funData[["Script"]]) < 2) stop("This function requires parsed output of multiple scripts.")

  lFun <- funData[["Macro_call"]]
  
  res <- list()
  for (i in seq_along(funData[["Script"]])) {
    if(identical(lFun[[i]], character(0))) lFun[[i]] <- NA
    res[[i]] <- data.frame(target=names(lFun[i]), src=lFun[[i]])
  }    

  networkData <- na.omit(do.call(rbind, res))

  simpleNetwork(networkData, textColour='#666', opacity=0.9, fontSize=11, zoom=TRUE)
}
