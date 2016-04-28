#' Plot static network of SAS acripts
#'
#' Plot is rendered in a graph window by Default. Alternatively, a pdf file can be created by specifying the file name.
#'
#' @param networkobj The network object which can be produced by \code{\link{createNetwork}}.
#' @param displayisolates Should isolates be displayed?
#' @param displaylabels Should vertex labels be displayed?
#' @param label.cex Character expansion factor for label text.
#' @param arrowhead.cex Expansion factor for edge arrowheads.
#' @param edge.lwd line width scale for edges.
#' @param vertex.col color for vertices; may be given as a vector or a vertex attribute name, if vertices are to be of different colors.
#' @param pdffile The file name if output PDF file.
#' @param width Width of PDF.
#' @param height Height of PDF.
#' @param ... other arguments e.g. \code{main} which is title, passed to \code{plot.network.default}
#' @return \code{NULL}. A png or pdf file.
#' @author Mango Solutions
#' @examples \dontrun{
#' library(sasMap)
#' sasDir <- system.file('examples/SAScode', package='sasMap')
#' net <- renderNetwork(sasDir)
#' plotSASmap(net)
#' plotSASmap(net, pdffile='static_sas_map.pdf', width=10, height=10)
#' }
#' @export
plotSASmap <- function(networkobj, displayisolates = FALSE, displaylabels = TRUE,
		label.cex = 1, arrowhead.cex = 0.8, edge.lwd = 0.1,vertex.col = rep(2, networkobj$gal$n),
		pdffile,  width = 5, height = 5, ...) {
	if (!missing(pdffile)) pdf(file = pdffile, width = width, height = height)
    if (all.isolated(networkobj)) {
        if (!displayisolates) {
            warning('All vertexes are isolated, force displayisolates to TRUE')
            displayisolates <- TRUE
        }
    }
	plot(networkobj, displayisolates = displayisolates, displaylabels = displaylabels,
			boxed.labels = TRUE, arrowhead.cex = arrowhead.cex, edge.lwd = edge.lwd,
			label.cex = label.cex, vertex.col = vertex.col, ...)
	if (!missing(pdffile)) dev.off()
}

#' Util function all.isolated
#'
#' Test if all vertexes are isolated
#' @param n network object
#' @return logical
all.isolated <- function(n) {
  stopifnot(is(n, 'network'))
  all(sapply(n$iel, length) + sapply(n$oel, length) == 0)
}
