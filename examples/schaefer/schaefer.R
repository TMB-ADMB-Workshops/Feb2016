hake <- read.table("schaefer.dat", header=TRUE)
names(hake) <- c("t", "C", "I")
parameters <- list(logR=-1.1, logK=8.0, logQ=-7.9, logSigma=-2.3)

require(TMB)
compile("schaefer.cpp")
dyn.load(dynlib("schaefer"))

################################################################################

model <- MakeADFun(hake, parameters)
fit <- nlminb(model$par, model$fn, model$gr)
rep <- sdreport(model)

print(summary(rep))

################################################################################

hake$B <- model$report()$B
hake$Ihat <- model$report()$Ihat

par(mfrow=c(1,2))
matplot(hake$t, hake[c("C","B")], type="l",
        xlab="Year", ylab="Biomass and Catch (kt)")
plot(I~t, hake, ylim=c(0,1.1*max(hake$I)), yaxs="i")
lines(Ihat~t, hake)
