data <- list()
data$minAge <- 1
data$maxAge <- 15
data$minYear <- 1991 
data$maxYear <- 2015        
data$catchNo <- as.matrix(read.table("pollcatno.dat")        )
data$stockMeanWeight <-as.matrix(read.table("wtage.dat"))
data$propMature <- as.matrix(read.table("pmature.dat"))
data$M <- as.matrix(read.table("pollM.dat"))
data$minAgeS <- 1
data$maxAgeS <- 15
data$minYearS <- 1991
data$maxYearS <- 2015
data$surveyTime <- .5
data$Q1 <- as.matrix(read.table("surveyNage.dat"))
             
