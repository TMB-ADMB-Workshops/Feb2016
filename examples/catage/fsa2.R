load("fsa.RData") # gets "dat"

library(TMB)
compile("fsa2.cpp")
dyn.load(dynlib("fsa2"))

parameters <- list(
  logN1Y=rep(0,nrow(dat$catchNo)),
  logN1A=rep(0,ncol(dat$catchNo)-1),
  logFY=rep(0,ncol(dat$catchNo)),
  logFA=rep(0,nrow(dat$catchNo)),
  logVarLogCatch=c(0,0), 
  logQ=rep(0,nrow(dat$Q1)),
  logVarLogSurvey=0
)
obj <- MakeADFun(dat,parameters,DLL="fsa2", map=list(logFA=factor(c(1:4,NA,NA,NA))), silent=TRUE)

opt <- nlminb(obj$par, obj$fn, obj$gr, control=list(iter.max=1000,eval.max=1000))
rep <- sdreport(obj)
srep<-summary(sdreport(obj))
ssb<-srep[rownames(srep)=="ssb",]

plot(ssb[,1], type="l", lwd=5, col="red", ylim=c(0,550000))
lines(ssb[,1]-2*ssb[,2], type="l", lwd=1, col="red")
lines(ssb[,1]+2*ssb[,2], type="l", lwd=1, col="red")




