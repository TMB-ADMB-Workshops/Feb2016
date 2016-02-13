
setwd("C:/Users/James.Thorson/Desktop/Project_git/TMB_experiments/experiment_with_parallel_accumulator")

library(TMB)
set.seed(123)
x <- seq(0,10,length=50001)
data <- list(Y=rnorm(length(x))+x,x=x)
parameters <- list(a=0,b=0,logSigma=0)
compile( "linreg_parallel.cpp" )
dyn.load(dynlib("linreg_parallel"))
obj <- MakeADFun(data,parameters,DLL="linreg_parallel")
obj$hessian <- TRUE
opt <- do.call("optim",obj)

#########################
# Experiment with parallelization
#########################

# Parallelized experimentations
#ben <- benchmark(obj, n=1e3, cores=1:4)
#plot(ben)

# Parallel
ben <- benchmark(obj, n=1000, cores=1:4, expr=expression(do.call("optim",obj)))
png( file="Benchmark.png", width=6, height=6, res=200, units="in")
  plot(ben)
dev.off()

##########################
# Help file version
##########################

runExample("linreg_parallel",thisR=TRUE) ## Create obj
ben <- benchmark(obj,n=100,cores=1:4)
plot(ben)
ben <- benchmark(obj,n=10,cores=1:4,expr=expression(do.call("optim",obj)))
plot(ben)


