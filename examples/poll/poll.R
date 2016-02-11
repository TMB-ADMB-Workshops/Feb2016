setwd("~/_mymods/tmb/Feb2016/examples/poll/")
#load("fsa.RData") # gets "dat"
source("polldat.R")
library(TMB)
compile("poll.cpp")
dyn.load(dynlib("poll"))

parameters <- list(
  logN1Y=rep(0,nrow(data$catchNo)),
  logN1A=rep(0,ncol(data$catchNo)-1),
  logFY=rep(0,ncol(data$catchNo)),
  logFA=rep(0,nrow(data$catchNo)),
  logVarLogCatch=c(0,0), 
  logQ=rep(0,nrow(data$Q1)),
  logVarLogSurvey=0
)
names(parameters)
names(data$catchNo)
obj <- MakeADFun(data,parameters,DLL="poll", map=list(logFA=factor(c(1:12,NA,NA,NA))))
opt <- nlminb(obj$par, obj$fn, obj$gr, control=list(iter.max=1000,eval.max=1000))
rep <- sdreport(obj)
srep<-summary(sdreport(obj))
ssb<-srep[rownames(srep)=="ssb",]

plot(ssb[,1], type="l", lwd=5, col="red", ylim=c(0,550000))
lines(ssb[,1]-2*ssb[,2], type="l", lwd=1, col="red")
lines(ssb[,1]+2*ssb[,2], type="l", lwd=1, col="red")

summary(rep)



