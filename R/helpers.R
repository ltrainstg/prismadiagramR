createPrisma <-  function(prismaFormat){
  prismaFormat$NodeName <- paste0(prismaFormat$nodeType, seq_along(prismaFormat$nodeType))
  # initialize
  formatNode <- getFormatNode( prismaFormat)
  # Add Source
  labelNode <- getLabelNode( prismaFormat)
  # Add Middle 
  rankNode <- getRankNode( prismaFormat)
  # Add End
  connectNode <- getConnectNode( prismaFormat)
  
  dot_template <-
    sprintf(
      "digraph prisma {
node [shape=\"box\"]
graph [splines=ortho, nodesep=1]
%s
%s
%s
%s
}", 
      formatNode, 
      labelNode, 
      rankNode, 
      connectNode
    )
  
  return(dot_template)
}
getFormatNode<- function(prismaFormat){
  prismaLvl <- nodeType <- NodeName <- NULL
  fontSize <- formatNode <- NULL
  if(!("fontSize" %in% names(prismaFormat))){
    warning("fontSize param not passed in prismaFormat")
    prismaFormat$fontSize <- 10
  }
  
  
  formatLines <- prismaFormat %>%
    mutate(formatNode =
             sprintf("%s[fontsize=%s]",
                     NodeName, 
                     fontSize)) %>% 
    pull(formatNode) 
    paste(formatLines, collapse = "\n")
  
  
}
getLabelNode<- function(prismaFormat){
  prismaLvl <- nodeType <- NodeName <- NULL
  prismaTxt <- labelNode <- NULL
  labelLines <- prismaFormat %>%
    mutate(labelNode =
             sprintf("%s[label=\"%s\n\"]",
                     NodeName, 
                     prismaTxt)) %>% 
    pull(labelNode) 
    paste(labelLines, collapse = "\n")
  
  
}
getRankNode<- function(prismaFormat){
  prismaLvl <- nodeType <- NodeName <- rankLabel <- NULL
  
 rankLines <-  prismaFormat%>% 
    group_by(prismaLvl) %>% 
    summarise(rankLabel = sprintf("{rank=same;%s}",
                                  paste(NodeName ,collapse = " "))) %>% 
    pull(rankLabel)  
    paste( rankLines, collapse = "\n")
  
  
  
  
}
getConnectNode<- function(prismaFormat){
prismaLvl <- nodeType <- NodeName <- NULL
  dot_template <- ""
  for(i in 1:(max(prismaFormat$prismaLvl)-1)){
    
    fromNodeInd <-which(prismaFormat$prismaLvl == i)
    toNodeInd <- which(prismaFormat$prismaLvl == i+1)
    
    # Connect to next level if one of these  
    for(fromInd in fromNodeInd){
      for(toInd in toNodeInd){
        fromNode <-prismaFormat$NodeName[fromInd]
        toNode   <- prismaFormat$NodeName[toInd]
        fromType <- prismaFormat$nodeType[fromInd]
        toType <- prismaFormat$nodeType[toInd]
        # we can only connect to these node types
        if(all(fromType == "Node", toType == "Node")) dot_template <- paste0(dot_template, connectNodes(fromNode, toNode))
        if(all(fromType == "Node", toType == "End")) dot_template <- paste0(dot_template, connectNodes(fromNode, toNode))
        if(all(fromType == "Source", toType == "Node")) dot_template <- paste0(dot_template, connectNodes(fromNode, toNode))
        
      }
    }  
    
    # Connect on same level if 1 Node and 1 Filter on a level  
    only2Nodes <- prismaFormat %>% filter(prismaLvl == i) %>% nrow()
    hasNode <- "Node" %in% (prismaFormat %>% filter(prismaLvl == i) %>% pull(nodeType) )
    hasFilter  <- "Filter" %in% (prismaFormat %>% filter(prismaLvl == i) %>% pull(nodeType) )
    if(all( only2Nodes, hasNode, hasFilter)){
      
      fromNode <- prismaFormat %>% filter(prismaLvl == i) %>% filter(nodeType == "Node") %>% pull(NodeName)
      toNode <- prismaFormat %>% filter(prismaLvl == i) %>% filter(nodeType == "Filter")  %>% pull(NodeName)
      dot_template <- paste0(dot_template, connectNodes(fromNode, toNode))
    }
    
    
    
  }
  
  return(dot_template)
  
  
}
connectNodes <- function(nodeName1, nodeName2) {
  connectStatment <- paste0(nodeName1, " -> ", nodeName2, "\n")
  return(connectStatment)
}