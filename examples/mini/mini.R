data <- list(x=rivers)
parameters <- list(mu=0,logSigma=0)

require(TMB)
## This with these compiler options reduces "optimization" and makes it compile faster
compile('mini.cpp' ,' -O0 -Wall')
dyn.load(dynlib('mini'))
##################
model <- MakeADFun(data,parameters)
fit   <- nlminb(model$par, model$fn, model$gr)
rep   <- sdreport(model)
rep
