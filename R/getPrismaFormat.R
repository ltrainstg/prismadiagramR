#' Create Prisma
#' These functions create a PRISMA diagram from a simple dataframe keeping track of sources and filters
#' It creates a DiagrammeR file run by grV
#' @param studyStatus a dataframe that keeps track of studies used.
#'
#' @return prismaFormat A dataframe with information on how to make a PRISMA diagram. 
#' @import dplyr
#' @import DiagrammeR
#' @examples 
#' prismaTemplate <- getPrisma(studyStatus)
#' prismaFormat <- getPrismaFormat(studyStatus)
#' prismaTemplate <- getPrisma(studyStatus, prismaFormat)
#' DiagrammeR::grViz(prismaTemplate)
#' @export
getPrismaFormat <- function(studyStatus){
  Source<-prismaTxt <- N <- NULL
  Source.df <- studyStatus %>% 
    group_by(Source) %>% 
    summarise(prismaLvl = 1, 
              nodeType = "Source",
              prismaTxt = n()) %>%  ungroup() %>% 
    mutate(prismaTxt = 
             sprintf("Source: %s\n(N=%s)", Source, prismaTxt)) %>% 
    select(-Source)
  
  
  Filter.df <- studyStatus %>% filter(!is.na(Filter)) %>% 
    group_by(Filter) %>% 
    summarise(prismaLvl = 1, 
              nodeType = "Filter",
              N = n(),
              prismaTxt = n()) %>%  ungroup() %>% 
    mutate(prismaTxt = 
             sprintf("Filter: %s\n(N=%s)", Filter, prismaTxt)) %>% 
    select(-Filter)
  Filter.df$prismaLvl <- seq(1:nrow(Filter.df)) + 1
  
  Node.df <- Filter.df
  Filter.df <- Filter.df %>% select(-N)
  Node.df$nodeType <- "Node"
  Node.df$prismaLvl <- seq(1:nrow(Filter.df)) + 1
  Node.df$N <- nrow(studyStatus)- cumsum(Node.df$N)
  
  Node.df <-  Node.df %>% mutate(prismaTxt = 
                                   sprintf("Studies Remaining: \n(N=%s)", N)) %>% select(-N)
  
  
  End.df <- studyStatus %>% filter(is.na(Filter)) %>% 
    group_by(Filter) %>% 
    summarise(prismaLvl = max(Filter.df$prismaLvl)+1, 
              nodeType = "End",
              prismaTxt = n()) %>%  ungroup() %>% 
    mutate(prismaTxt = 
             sprintf("Studies in Analysis\n(N=%s)", prismaTxt)) %>% 
    select(-Filter)
  
  
  
  
  
  prismaFormat <- rbind( Source.df, Filter.df)
  prismaFormat <- rbind( prismaFormat, Node.df )
  prismaFormat <- rbind( prismaFormat, End.df )
  return(prismaFormat)
}