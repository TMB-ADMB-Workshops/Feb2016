setwd("~/_mymods/tmb/Feb2016/examples/poll/")
#load("fsa.RData") # gets "dat"
source("polldat.R")
library(TMB)
compile("poll.cpp","-O0 -g")
dyn.load(dynlib("poll"))

parameters <- list(
  logN1Y=rep(0,ncol(data$catchNo)),
  logN1A=rep(0,nrow(data$catchNo)-1),
  logFY=rep(0,nrow(data$catchNo)),
  logFA=rep(0,ncol(data$catchNo)),
  logVarLogCatch=c(0,0), 
  logQ=rep(0,ncol(data$Q1)),
  logVarLogSurvey=0
)
names(parameters)
names(data)
data$propMature
(data$Q1)
(data$catchNo <- data$catchNo + 1e-3)
data$catchNo
(parameters$logQ)
obj <- MakeADFun(data,parameters,DLL="poll", map=list(logFA=factor(c(1:12,NA,NA,NA))))
opt <- nlminb(obj$par, obj$fn, obj$gr, control=list(iter.max=1000,eval.max=1000))
obj$gr()
rep <- sdreport(obj,bias.correct=TRUE)
rep <- sdreport(obj,bias.correct=FALSE)
rm(rep)
rep
args(sdreport)
srep<-summary(sdreport(obj))
ssb<-srep[rownames(srep)=="ssb",]

plot(ssb[,1], type="l", lwd=5, col="red" , ylim=c(0,1.5e7))
lines(ssb[,1]-2*ssb[,2], type="l", lwd=1, col="red")
lines(ssb[,1]+2*ssb[,2], type="l", lwd=1, col="red")

summary(rep)



