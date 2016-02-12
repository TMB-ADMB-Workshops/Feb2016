load("sam.RData")

parameters <- list(
  logFpar=numeric(max(data$keyLogFpar)+1)-5, 
  logQpow=numeric(max(data$keyQpow)+1),
  logSdLogFsta=numeric(max(data$keyVarF)+1)-.7,
  logSdLogN=numeric(max(data$keyVarLogN)+1)-.35,
  logSdLogObs=numeric(max(data$keyVarObs)+1)-.35,
  rec_loga=if(data$stockRecruitmentModelCode==0){numeric(0)}else{numeric(1)}, 
  rec_logb=if(data$stockRecruitmentModelCode==0){numeric(0)}else{numeric(1)}, 
  logit_rho=numeric(1)+.5, 
  logScale=numeric(data$noScaledYears),  
  logScaleSSB=if(any(data$fleetTypes%in%c(3,4))){numeric(1)}else{numeric(0)},
  logPowSSB=if(any(data$fleetTypes==4)){numeric(1)}else{numeric(0)},
  logSdSSB=if(any(data$fleetTypes%in%c(3,4))){numeric(1)}else{numeric(0)},
  logF=matrix(0, nrow=max(data$keyLogFsta)+1,ncol=data$noYears),
  logN=matrix(0, nrow=data$maxAge-data$minAge+1, ncol=data$noYears),
  numdata=Inf
  )


library(TMB, quiet=TRUE)
compile("samtmb.cpp")
dyn.load(dynlib("samtmb"))

map <- list(numdata=factor(NA))
obj <- MakeADFun(data,parameters,random=c("logN","logF"),DLL="samtmb",map=map)

opt<-nlminb(obj$par,obj$fn,obj$gr,control=list(trace=1,eval.max=1200,iter.max=900))
obj$fn(opt$par);


pl <- obj$env$parList()
rep<-obj$report()
jointrep<-sdreport(obj, getJointPrecision=T)
allsd<-sqrt(diag(solve(jointrep$jointPrecision))) 
plsd <- obj$env$parList(par=allsd)
sdrep<-sdreport(obj)
