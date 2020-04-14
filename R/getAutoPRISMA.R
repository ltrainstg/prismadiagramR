#' Create Prisma
#'
#' @param prismaExampleInput a dataframe with 1 row per item in the prima diagram. 
#' @param fontsizehow large to make the characters in the diagram
#' @param labelBuffer number of characters to create "buffer" around text
#'
#' @return
#' @export
#' @import dplyr
#' @import DiagrammeR
#' @examples getAutoPRISMA(prismaExampleInput)
getAutoPRISMA <- function(prismaExampleInput, fontsize = 10,  labelBuffer = 0) {
  
  SourceInfo.df <-
    prismaExampleInput %>%
    group_by(Source, `Source Text`) %>%
    summarise(N = n())
  
  
  dot_template <- initilizePrisma(fontsize)
  ### This adds all the top level Source boxes
  for (i in 1:dim(SourceInfo.df)[1]) {
    dot_template <-
      paste0(dot_template,
             connectNodes(SourceInfo.df$Source[i], "Node1"))
    dot_template <-
      paste0(
        dot_template,
        labelNodes(
          SourceInfo.df$Source[i],
          SourceInfo.df$`Source Text`[i],
          SourceInfo.df$N[i],
          labelBuffer
        )
      )
  }
  Filter.df <- prismaExampleInput %>% group_by(Filter,
                                               `Filter Text`) %>%
    filter(!is.na(Filter)) %>%
    summarise(N = n())
  runSum <- dim(prismaExampleInput)[1]
  if(dim(Filter.df)[1] !=0){
    i <- 1
    
    
    
    for (i in 1:dim(Filter.df)[1]) {
      ### Create Filter side
      dot_template <-
        paste0(dot_template, connectNodes(paste0("Node", i), paste0("Filter", i)))
      dot_template <-
        paste0(dot_template,
               labelNodes(
                 paste0("Filter", i),
                 Filter.df$`Filter Text`[i],
                 Filter.df$N[i],
                 labelBuffer
               ))
      
      dot_template <- dot_template %>% paste0(.,
                                              labelNodes(paste0("Node", i),
                                                         sprintf("This is %s", i),
                                                         runSum,
                                                         labelBuffer))
      
      runSum <- runSum - Filter.df$N[i]
      dot_template <- paste0(dot_template,
                             rankSame(paste0("Node", i), paste0("Filter", i)))
      
      dot_template <- dot_template %>% paste0(.,
                                              labelNodes(
                                                paste0("Filter", i),
                                                Filter.df$`Filter Text`[i],
                                                Filter.df$N[i],
                                                labelBuffer
                                              ))
      
      ## Next Node
      
      dot_template <-
        paste0(dot_template, connectNodes(paste0("Node", i), paste0("Node", i +
                                                                      1)))
      
      
    }
    dot_template <- paste0(dot_template, labelNodes(paste0("Node", i + 1),
                                                    paste0("This is the Final Node ", i),
                                                    runSum,
                                                    labelBuffer))
  } else{
    ### Create Filter side
    
    dot_template <- paste0(dot_template, labelNodes(paste0("Node", 1),
                                                    paste0("All Studies used ", 1),
                                                    runSum,
                                                    labelBuffer))
    
  }
  ### Finish the template
  dot_template <- dot_template %>% paste0(., '}')
  
  dot_template %>% DiagrammeR::grViz(.)
  
  
  
}

initilizePrisma <- function(fontsize) {
  prismaStem <- sprintf("digraph prisma {\n\n
node [shape=\"box\",\n fontsize=%s];\n
graph [splines=ortho, nodesep=1]\n\n", fontsize)
  
  return(prismaStem)
}

connectNodes <- function(nodeName1, nodeName2) {
  connectStatment <- paste0(nodeName1, " -> ", nodeName2, "\n")
  
  return(connectStatment)
  
}

labelNodes <- function(nodeName, nodeLabel, nodeNum, labelBuffer) {
  labelBuffer <-  rep(" ",labelBuffer) %>% paste(., collapse = "")
  nodeLabel <- sprintf("%s%s%s", labelBuffer, nodeLabel, labelBuffer)
  labelStatment <-
    paste0(nodeName, "[label=\"", nodeLabel, "\n(n = ", nodeNum, ")\"];\n")
  
  return(labelStatment)
  
  
}

rankSame <- function(nodeName1, nodeName2) {
  rankStatment <- paste("{rank=same;", nodeName1, nodeName2, "}")
  return(rankStatment)
  
}