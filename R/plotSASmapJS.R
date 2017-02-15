#' Plot interactive network of SAS scripts
#'
#' It creates basic force directed network graphics with depends on the networkD3 package.
#'
#' @param dirPath Path to the folder that holds all SAS scripts (> 1)
#' @return \code{NULL}.
#' @author Mango Solutions
#' @examples \dontrun{
#' library(sasMap)
#' sasDir <- system.file('examples/SAScode', package='sasMap')
#' plotSASmapJS(sasDir)
#' }
#' @importFrom tidyr gather
#' @import dplyr
#' @import visNetwork
#' @export
plotSASmapJS <- function(dirPath){
  
  networkData <- calNetwork(dirPath = dirPath)
  
  visNetwork(nodes = networkData$nodes, edges = networkData$edges, width = "100%") %>%
    visOptions(selectedBy = list(variable = "group", multiple = TRUE),
               highlightNearest = list(enabled = TRUE,
                                       degree = 1),
               nodesIdSelection = list(useLabels = TRUE)
    ) %>%
    visEdges(arrows = list(to = list(enabled = TRUE, scaleFactor = 1))) %>%
    visInteraction(dragNodes = TRUE,
                   dragView = TRUE,
                   zoomView = TRUE) %>%
    visExport() %>%
    visLayout(randomSeed = 12)
  
}

#' Find nodes from edges
#' 
#' @param dirPath  Path to the folder that holds all SAS scripts
calNetwork <- function(dirPath) {
  edges <- findEdges(dirPath = dirPath)
  nodes <- findNodes(edges, dirPath = dirPath)
  
  nodelevels <- levels(nodes$label)
  
  edges <- edges %>%
    mutate(from = factor(from, levels = nodelevels),
           to = factor(to, levels = nodelevels)) %>%
    left_join(nodes, by = c("from" = "label")) %>% 
    left_join(nodes, by = c("to" = "label")) %>%
    select(from = id.x,
           to = id.y) 
  
  return(list(nodes = nodes, edges = edges))
}

#' Extract edges dataset
#' 
#' @param dirPath Path to the folder that holds all SAS scripts
#' @examples \dontrun{
#' library(sasMap)
#' sasDir <- system.file('examples/SAScode', package='sasMap')
#' findEdges(sasDir)
#' }
findEdges <- function(dirPath) {
  if(missing(dirPath)) stop("Please provide a path to the sas folder.")
  if (file.info(dirPath)$isdir) {funData <- parseSASfolder(dirPath, output='list')}
  if(length(funData[["Script"]]) < 2) stop("Please provide more than one sas script.")
  
  lFun <- funData[["Macro_call"]]
  
  res <- list()
  for (i in seq_along(funData[["Script"]])) {
    if(identical(lFun[[i]], character(0))) lFun[[i]] <- NA
    res[[i]] <- data.frame(from=names(lFun[i]), to=lFun[[i]])
  }    
  
  networkData <- na.omit(do.call(rbind, res))
  return(networkData)
}

#' Find nodes from edges
#' 
#' @param edges The overall edges dataset including both natural and assessed edges
#' @param dirPath  Path to the folder that holds all SAS scripts
#' @param sas.pattern SAS script extension
#' 
#' @examples \dontrun{
#' library(sasMap)
#' sasDir <- system.file('examples/SAScode', package='sasMap')
#' edges <- findEdges(sasDir)
#' nodes <- findNodes(edges, sasDir)
#' } 
findNodes <- function(edges, dirPath, sas.pattern = "\\.[Ss][Aa][Ss]$") {
  if(missing(edges)) stop("Please provide an edges data.frame")
  
  toplevel.scripts <- casefold(
    sub(
      sas.pattern, "", basename(dir(dirPath, pattern = sas.pattern))
    )
  )
  
  lowlevel.scripts <- casefold(
    sub(
      sas.pattern, "", basename(dir(dirPath, pattern = sas.pattern, recursive = TRUE))
    )
  ) 
  lowlevel.scripts <- lowlevel.scripts[!lowlevel.scripts %in% toplevel.scripts]
  
  nodesColors <- data.frame(
    group = c("sub scripts", "top scripts", "internal macros"),
    color = c("#A6CEE3", "#1F78B4", "#FB9A99"), 
    stringsAsFactors=FALSE
  )
  
  data.frame(label = union(edges$from, edges$to)) %>%
    mutate(id = 1:n()) %>%
    mutate(group = ifelse(label %in% toplevel.scripts, 
                          "top scripts", 
                          ifelse(label %in% lowlevel.scripts, "sub scripts", "internal macros"))
             ) %>%
    left_join(nodesColors, by =  "group")
    
}
