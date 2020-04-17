


test_that("test new print", {
  
  set.seed(25)
  N <- 100
  studyStatus <- data.frame(Pub.ID = seq(1:N), 
                            Source = sample(1:3, N, replace = TRUE),
                            Filter = sample(1:5, N, replace = TRUE))
  studyStatus$Filter[studyStatus$Filter==5] <- NA  
  
  getPrisma(studyStatus) %>% DiagrammeR::grViz(.)
  prismaFormat <- getPrismaFormat(studyStatus)
  prismaFormat$prismaTxt[2] <- "Medline Search \n (N=32)"
  getPrisma(studyStatus, prismaFormat) %>% DiagrammeR::grViz(.)
  prismaFormat$prismaTxt[4] <-  "Filter: No Timepoint\n(N=24)"
  getPrisma(studyStatus, prismaFormat) %>% DiagrammeR::grViz(.)
  prismaFormat$fontSize <- 20
  getPrisma(studyStatus, prismaFormat) %>% DiagrammeR::grViz(.)
  prismaFormat$prismaLvl[which(prismaFormat$prismaLvl !=1)] <- prismaFormat$prismaLvl[which(prismaFormat$prismaLvl !=1)] +1
  prismaFormat <-
    data.frame(prismaLvl = 2,
               nodeType = "Node", 
               prismaTxt = "100 studies",
               fontSize=15) %>% 
    rbind(., prismaFormat)
  getPrisma(studyStatus, prismaFormat) %>% DiagrammeR::grViz(.)
  
})

