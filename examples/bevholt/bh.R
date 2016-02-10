# bh.R
# Beverton-Holt Model R                = aS/(1+bS)*exp(-epsilon*sigR)
library(TMB)

data <- read.table("bevholt.dat",header=TRUE)
data <- list(R    =data$R,S=data$S)
pars <- list(log_a= log(2.1), log_b = 0, log_sig = 0, log_tau = log(0.1),
		 u        = rep(0,length=length(data$S)))

compile("bh.cpp")
dyn.load(dynlib("bh"))

# f   <- MakeADFun(data,parameters=pars,random=c("u"),ADreport = FALSE)
f   <- MakeADFun(data,parameters=pars,map=list(log_tau=factor(c(NA))))
fit <- nlminb(f$par,f$fn,f$gr) 



mle <- f$env$last.par.best
rep <- sdreport(f)

print(mle)
print(summary(rep))

plot(data$S,data$R,pch=20,col=1)
points(f$report(),pch =20,col=2)