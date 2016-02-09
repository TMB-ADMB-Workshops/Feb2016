library(TMB)
compile("scalar.cpp")
dyn.load(dynlib("scalar"))

data <- list()

param <- list()
param$mu <- 0

obj <- MakeADFun(data,param, DLL="scalar")

opt <- nlminb(obj$par, obj$fn, obj$gr)
opt$par

