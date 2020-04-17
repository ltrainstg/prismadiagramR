#' Create Prisma
#' These functions create a PRISMA diagram from a simple dataframe keeping track of sources and filters
#' It creates a DiagrammeR file run by grV
#' @param studyStatus a dataframe that keeps track of 
#' @param prismaFormat how large to make the characters in the diagram
#'
#' @return prismaTemplate A text file use to make a PRISMA diagram. 
#' @import dplyr
#' @import DiagrammeR
#' @examples 
#' prismaTemplate <- getPrisma(studyStatus)
#' prismaFormat <- getPrismaFormat(studyStatus)
#' prismaTemplate <- getPrisma(studyStatus, prismaFormat)
#' DiagrammeR::grViz(prismaTemplate)
#' @export
getPrisma <- function(studyStatus =NULL, prismaFormat = NULL){
  

  
  if(is.null(prismaFormat)){
    reqNames <- c("Source", "Filter")
    missNames <- setdiff(reqNames, names(studyStatus))
    if(length(missNames) != 0 ) stop(sprintf("%s not in studyStatus argument.",  paste(missNames, collapse = " and ")))
    warning("prismaFormat is null so attempting to make automatic one from studyStatus")
    prismaFormat <- getPrismaFormat(studyStatus)
    
  }
  
  reqNames <- c("Source", "Node","Filter", "End")
  if(!all(prismaFormat$nodeType %in% reqNames) ) stop("Check nodeType some of these not allowed")
  
  createPrisma(prismaFormat)
  
  
  
  
}



