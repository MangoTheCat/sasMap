#' List proc calls
#'
#' This function reports counts of proc calls by group.
#'
#' @param procsCol Character or factor indicating the Procs from the descSASscript output
#' @return \code{data.frame}.
#' @author Mango Solutions
#' @examples \dontrun{
#' library(sasMap)
#' sasDir <- system.file('examples/SAScode', package='sasMap')
#' listProcs(parseSASfolder(sasDir)$Procs)
#' }
#' @export
listProcs  <- function(procsCol) {
  if(missing(procsCol)) stop('Please pass the Procs column to this argument')
  if(!(is.factor(procsCol) | is.character(procsCol))) stop('Procs column is a character or factor vector')

  Proc <- NULL
  N <- NULL

  x <- procsCol
  x <- paste0(x, collapse = ",")
  x <- unlist(strsplit(gsub(" ", "", x), ","))


  out <- do.call("rbind", lapply(x, function(txt) {
    whereBrack <- regexpr("\\(", txt)
    outVec <- substring(txt, c(1, whereBrack+1), c(whereBrack-1, whereBrack+1))
    data.frame(Proc = outVec[1], N = as.numeric(gsub("[^\\d]+", "", txt, perl=TRUE)))
  }))
  out <- aggregate(list(N = out$N), list(Proc = out$Proc), sum)
  out <- out [order(out$N, decreasing = TRUE), ]
  return(out)

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
#' out <- listProcs(parseSASfolder(sasDir)$Procs)
#' drawProcs(out)
#' }
#' @import ggplot2
#' @export

drawProcs <- function(procs) {

  procs <- na.omit(procs)

  g <- ggplot(procs, aes(x=reorder(Proc, N), y=N)) +
    geom_bar(stat='identity', fill="#F21E13") +
	  coord_flip() +
	  theme_minimal() +
	  geom_text(aes(label=N), hjust=-0.2, size=3) +
	  ggtitle("Most Common Procedure Calls") + ylab("Number of calls") + xlab(NULL)

  print(g)

}
