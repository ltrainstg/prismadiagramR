# ## code to prepare `DATASET` dataset goes here
# 
# usethis::use_data("DATASET")
# set.seed(25)
# N <- 10
# fromA <- sample(1:10,1)
# filterA <- sample(1:10, 1)
# prismaExampleInput <- data.frame(Source = c(rep("A", fromA), rep("B", N-fromA)), 
#                                  Filter = c(rep("Filter A", filterA), rep("Filter B", N-filterA))
# )
# prismaExampleInput$`Source Text` <-   prismaExampleInput$Source
# prismaExampleInput$`Filter Text` <-   prismaExampleInput$Filter
# 
