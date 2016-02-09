data <- read.table("linreg.dat", header=TRUE)
parameters <- list(b0=0, b1=0, logSigma=0)

require(TMB)
compile("linreg.cpp")
dyn.load(dynlib("linreg"))

################################################################################

model <- MakeADFun(data, parameters, DLL="linreg")
fit <- nlminb(model$par, model$fn, model$gr)

best <- model$env$last.par.best
rep <- sdreport(model)

print(best)
print(rep)
