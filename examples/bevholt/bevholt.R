data <- read.table("bevholt.dat", header=TRUE)
## plot(R~S, data, xlim=c(0,400), ylim=c(0,200))

parameters <- list(logRmax=log(400), logS50=log(100), logSigma=0)

require(TMB)
compile("bevholt.cpp")
dyn.load(dynlib("bevholt"))

################################################################################

model <- MakeADFun(data, parameters, DLL="bevholt")
fit <- nlminb(model$par, model$fn, model$gr)

best <- model$env$last.par.best
rep <- sdreport(model)

print(best)
print(rep)
summary(rep)

Svec <- seq(0, 4000, 20)
Rmax <- exp(best[["logRmax"]])
S50 <- exp(best[["logS50"]])
Rvec <- Rmax * Svec / (Svec + S50)
## lines(Rvec~Svec)
