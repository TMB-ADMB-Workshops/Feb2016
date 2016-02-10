setwd("~/_mymods/tmb/Feb2016/examples/andre")
 hake <- read.table("schaefer.dat", header = TRUE)
names(hake) <- c("t", "C", "I")
parameters  <- list(logR=-1.1, logK=8.0, logQ=-7.9, logSigma=-2.3)

require(TMB)
compile("schaefer.cpp")
dyn.load(dynlib("schaefer"))

################################################################################

model <- MakeADFun(hake, parameters,DLL="schaefer")
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
args(mcmc)
# Set up some method to getting parameter set (draws of posterior eg)
nuts <- mcmc(model, 500, "NUTS",eps=.003)
names(nuts)
summary(nuts)
# Store some part of ADREPORT() (in this case B) from the model given those parameter vectors
dd = NULL
for (i in 1:nrow(nuts)) {
	dd[[i]] <- model$report(nuts[i,])$B
}
dd
boxplot(as.data.frame(t(as.data.frame(dd))))

args(model$report )
str(nuts)
cor(nuts$logR,nuts$logK)
plot(nuts$logR,nuts$logK)
mcmc(model, 500, "RWM",eps=.001)
warnings()