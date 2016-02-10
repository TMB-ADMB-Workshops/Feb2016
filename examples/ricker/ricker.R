data <- read.table("ricker.dat", header=TRUE)[-1]
## plot(R~S, data, xlim=c(0,4000), ylim=c(0,1800))

parameters <- list(loga=log(5), logb=log(0.002), logSigma=0)

require(TMB)
compile("ricker.cpp")
dyn.load(dynlib("ricker"))

################################################################################

model <- MakeADFun(data, parameters, DLL="ricker")
fit <- nlminb(model$par, model$fn, model$gr)

best <- model$env$last.par.best
rep <- sdreport(model)

print(best)
print(rep)

Svec <- seq(0, 4000, 20)
a <- exp(best[["loga"]])
b <- exp(best[["logb"]])
Rvec <- a * Svec * exp(-b*Svec)
## lines(Rvec~Svec)
