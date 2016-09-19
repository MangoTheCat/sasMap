#' List proc calls
#'
#' This function reports counts of proc calls by group.
#'
#' @param filepath Path to single sas file or folder
#' @return \code{data.frame}
#' @author Mango Solutions
#' @examples \dontrun{
#' library(sasMap)
#' sasDir <- system.file('examples/SAScode', package='sasMap')
#' listProcs(sasDir)
#' }
#' @export
listProcs <- function(filepath){
  if (file.info(filepath)$isdir) {sasCode <- parseSASfolder(filepath, output = "list")}
  else {sasCode <- parseSASscript(filepath, output = "list")}  
  
  if (is.null(sasCode$Procs))  return(NULL)
    
  procs <- data.frame(table(unlist(sasCode$Procs)))
  names(procs) <- c("Proc", "N")
  procs <- procs [order(procs$N, decreasing = TRUE), ]
  return(procs)
}

#' Draw the frequency of proc calls
#'
#' Draw a barplot based on the frequency.
#'
#' @param procs data.frame output from the listProcs function, i.e. counts by procs.
#' @return \code{NULL}.
#' @author Mango Solutions
#' @examples \dontrun{
#' library(sasMap)
#' sasDir <- system.file('examples/SAScode', package='sasMap')
#' drawProcs(sasDir)
#' }
#' @export
#' @import ggplot2
drawProcs <- function(filepath) {
  
  procs <- listProcs(filepath)
  procs <- na.omit(procs)

  g <- ggplot(procs, aes(x=reorder(Proc, N), y=N)) +
    geom_bar(stat='identity', fill="#F21E13") +
	  coord_flip() +
	  theme_minimal() +
	  geom_text(aes(label=N), hjust=-0.2, size=3) +
	  ggtitle("Most Common Procedure Calls") + ylab("Number of calls") + xlab(NULL)

  g

}
