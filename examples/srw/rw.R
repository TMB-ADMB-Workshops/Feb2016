data <- read.table("rw.dat", header=TRUE)
parameters <- list(predbiom=rep(0.0,24), logSdLam=0.0)
Random = c("predbiom")

require(TMB)
compile("rw.cpp","-O0 -g")
dyn.load(dynlib("rw"))

################################################################################

model <- MakeADFun(data, parameters, DLL="rw", random=Random)
model2 <- MakeADFun(data, parameters, DLL="rw")
fit2 <- nlminb(model2$par, model2$fn, model2$gr)
fit <- nlminb(model$par, model$fn, model$gr)
exp(fit2$par)
sdreport(model,bias.correct=TRUE,bias.correct.control = list(sd=TRUE))
str(sdreport(model,bias.correct=TRUE))

best <- model$env$last.par.best
rep <- sdreport(model)

print(best)
print(rep)

plot(exp(model$rep()$predbiom), ylim=c(0,400000))
points(data$biom,col="red")
