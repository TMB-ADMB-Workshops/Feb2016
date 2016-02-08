data <- list(x=rivers)
parameters <- list(mu=0,logSigma=0)

require(TMB)
<<<<<<< HEAD
compile('mini.cpp') #,'-fno-gnu-unique -O0 -Wall')
=======
## This with these compiler options reduces "optimization" and makes it compile faster
compile('mini.cpp' ,' -O0 -Wall')
>>>>>>> 20de3cda4b95c2b9ad9c7d886ce4208d4c8b5982
dyn.load(dynlib('mini'))
##################
model <- MakeADFun(data,parameters)
fit   <- nlminb(model$par, model$fn, model$gr)
rep   <- sdreport(model)
<<<<<<< HEAD
=======
rep
>>>>>>> 20de3cda4b95c2b9ad9c7d886ce4208d4c8b5982
