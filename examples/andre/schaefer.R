setwd("~/_mymods/tmb/Feb2016/examples/andre")
hake <- read.table("schaefer.dat", header=TRUE)
names(hake) <- c("t", "C", "I")
Nyear <- length(hake$C)
parameters <- list(logR=-1.1, logK=8.0, logQ=-7.9, logSigma=-2.3,FF=rep(-2,Nyear))
print(parameters)

require(TMB)
compile("schaefer.cpp")
dyn.load(dynlib("schaefer"))

################################################################################

model <- MakeADFun(hake, parameters,DLL="schaefer")
# Added some options for nlminb 
fit <- nlminb(model$par, model$fn, model$gr,control=list(iter.max=1000,eval.max=1000))
names(fit)
fit$iterations

# Do some extra minimizations 
for (i in 1:3)
  fit <- nlminb(model$env$last.par.best , model$fn, model$gr)
model$gr(fit$par)
rep <- sdreport(model)

print(summary(rep))

################################################################################

hake$B <- model$report()$B[1:Nyear]
hake$Ihat <- model$report()$Ihat

par(mfrow=c(1,2))
matplot(hake$t, hake[c("C","B")], type="l",
        xlab="Year", ylab="Biomass and Catch (kt)")
plot(I~t, hake, ylim=c(0,1.1*max(hake$I)), yaxs="i")
lines(Ihat~t, hake)

