d <- list()
d$minAge <- 1
d$maxAge <- 15
d$minYear <- 1991 
d$maxYear <- 2015        
d$catchNo <- read.table("pollcatno.dat",header=F)        
d$stockMeanWeight <-read.table("wtage.dat")
d$propMature <- read.table("pmature.dat")
d$M <- c(.9,.45,rep(0.3,13))
d$minAgeS <- 1
d$maxAgeS <- 15
d$minYearS <- 1991
d$maxYearS <- 2015
d$surveyTime <- .5
d$Q1 <- read.table("surveyNage.dat")
             
