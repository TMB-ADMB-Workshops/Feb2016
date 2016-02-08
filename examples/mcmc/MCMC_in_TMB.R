## A VERY quick demo of MCMC capabilities in TMB. Note these are in beta form
## and use the latest Github development version for up-to-date
## code.... Started 2/8/2016 -- Cole Monnahan

## Bottom line: Use these algorithms with caution. Stan is a better option
## if you're only doing Bayesian models. NUTS is typically the best option.

## Note: bounded parameters not currently supported, so do those internally
## if needed.

library(TMB)
?mcmc

## This runs the simple and loads that model object in the workspace.
runExample("simple")


## Make model with random effects on 'u'. Note the starting values.
obj <- MakeADFun(data=list(x=x, B=B, A=A),
                 parameters=list(u=u*0, beta=beta*0, logsdu=1, logsd0=1),
                 random="u",
                 DLL="simple",
                 silent=TRUE)
opt <- optim(obj$par, obj$fn, obj$gr, hessian=TRUE)
opt$par
par.names <- names(opt$par)

## Run RWM and two gradient based algorithms, using fixed step size (eps)
## for each. Start from the MLE.
N <- 500
rwm <- mcmc(obj=obj, nsim=N*8, algorithm='RWM', params.init=opt$par,
            alpha=.08, diagnostic=TRUE)
## Thin it to better approximate the gradient methods
rwm$par <- rwm$par[seq(1, nrow(rwm$par), by=8),]
hmc <- mcmc(obj=obj, nsim=N, algorithm='HMC', L=8, params.init=opt$par,
            diagnostic=TRUE, eps=.1)
nuts <- mcmc(obj=obj, nsim=N, algorithm='NUTS', params.init=opt$par,
             diagnostic=TRUE, eps=.1, max_doubling=7)

pairs(nuts$par[-(1:(N/2)),])

## See how they compare via ACF
par(mfrow=c(3,4))
for(i in par.names) acf(rwm$par[-(1:(N/2)),i], main=i)
for(i in par.names) acf(hmc$par[-(1:(N/2)),i], main=i)
for(i in par.names) acf(nuts$par[-(1:(N/2)),i], main=i)
## End(Not run)

## Same object but no random effects this time! Have to use better starting
## values or it crashes big time.
obj2 <- MakeADFun(data=list(x=x, B=B, A=A),
                 parameters=list(u=u, beta=beta, logsdu=1, logsd0=1),
                 DLL="simple",
                 silent=TRUE)
opt2 <- optim(obj2$par, obj2$fn, obj2$gr, hessian=TRUE)
str(opt2$par)
covar <- solve(opt2$hessian)

rwm2 <- mcmc(obj=obj2, nsim=N*8, algorithm='RWM', params.init=opt2$par,
            alpha=.01 , diagnostic=TRUE, covar=covar)
## Thin it to better approximate the gradient methods
rwm2$par <- rwm2$par[seq(1, N*8, by=8),]
hmc2 <- mcmc(obj=obj2, nsim=N, algorithm='HMC', L=8,
            diagnostic=TRUE, eps=NULL)
nuts2 <- mcmc(obj=obj2, nsim=N, algorithm='NUTS', params.init=opt2$par,
             diagnostic=TRUE, max_doubling=7, eps=NULL)

## See how they compare via ACF
par(mfrow=c(3,4))
for(i in par.names) acf(rwm2$par[,i], main=i)
for(i in par.names) acf(hmc2$par[,i], main=i)
for(i in par.names) acf(nuts2$par[,i], main=i)
