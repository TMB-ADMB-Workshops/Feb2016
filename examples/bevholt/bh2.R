# bh.R
# Beverton-Holt Model R                = aS/(1+bS)*exp(-epsilon*sigR)
library(TMB)

data <- read.table("bevholt.dat",header=TRUE)
pars <- list(log_a=0, 
         	 log_b = 0, 
         	 log_sig = log(0.1), 
         	 log_tau = log(0.1),
		 	 u=rep(0,length=length(data$S))
		 	 )

compile("bh.cpp")
dyn.load(dynlib("bh"))

f   <- MakeADFun(data,parameters=pars,random=c("u"),ADreport = FALSE)
# f   <- MakeADFun(data,parameters=pars,map=list(log_tau=factor(c(NA))))
fit <- nlminb(f$par,f$fn,f$gr) 



mle <- f$env$last.par.best
rep <- sdreport(f)

print(mle)
print(summary(rep))

plot(data$S,data$R,pch=20,col=1)
points(f$report(),pch =20,col=2)


# Simulator
n   <- length(data$S)
tau <- 0.35
sig <- 0.10
rmax <- 1200
epi <- rnorm(n,0,sig)
psi <- rnorm(n,0,tau)
a   <- 5.0
b   <- a/rmax
X   <- data$S
S   <- X * exp(psi)
R   <- a*X / (1+b*X) * exp(epi)
xx <- seq(0,max(c(S,X,a/b)),length=n)
plot(xx,a*xx/(1+b*xx),col=1,lwd=2,type="l")
points(S,R); abline(a=0,b=1)

simdata <- list(R=data$R,S=data$S)
pars <- list(log_a=log(a), 
         	 log_b = log(b), 
         	 log_sig = log(sig), 
         	 log_tau = log(tau),
		 	 u=rep(0,length=length(data$S))
		 	 )
ff   <- MakeADFun(simdata,parameters=pars,random=c("u"),ADreport = FALSE)
fit <- nlminb(ff$par,ff$fn,ff$gr) 




