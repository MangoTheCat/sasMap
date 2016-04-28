#' Draw the frequency of proc calls
#'
#' It creates a static barplot using ggplot2.
#'
#' @param procsCol Character or factor indicating the Procs from the descSASscript output
#' @return \code{NULL}.
#' @author Mango Solutions
#' @examples \dontrun{
#' library(sasMap)
#' sasDir <- system.file('examples/SAScode', package='sasMap')
#' drawProcs(parseSASfolder(sasDir)$Procs)
#' }
#' @import ggplot2
#' @export

drawProcs <- function(procsCol) {
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
  out <- na.omit(out)

  g <- ggplot(out, aes(x=reorder(Proc, N), y=N)) +
    geom_bar(stat='identity', fill="#F21E13") +
	  coord_flip() +
	  theme_minimal() +
	  geom_text(aes(label=N), hjust=-0.2, size=3) +
	  ggtitle("Most Common Procedure Calls") + ylab("Number of calls") + xlab(NULL)

  print(g)

}
