
setwd( "C:/Users/James.Thorson/Desktop/Project_git/TMB_experiments/experiment_with_oneStepPredict" )

######################
# Simulate data
######################

Factor = rep( 1:10, each=10)
Z = rnorm( length(unique(Factor)), mean=0, sd=1)

X0 = 0

Y = Z[Factor] + X0 + rnorm( length(Factor), mean=0, sd=1)

######################
# Run in TMB
######################

library(TMB)

Version = c( "linear_mixed_model" )[1]
compile( paste0(Version,".cpp") )

Data = list( "n_data"=length(Y), "n_factors"=length(unique(Factor)), "Factor"=Factor-1, "Y"=Y)
Parameters = list( "X0"=-10, "log_SD0"=2, "log_SDZ"=2, "Z"=rep(0,Data$n_factor) )
Random = c("Z")

dyn.load( dynlib("linear_mixed_model") )
Obj = MakeADFun(data=Data, parameters=Parameters, random=Random)

# Prove that function and gradient calls work
Obj$fn( Obj$par )
Obj$gr( Obj$par )

# Optimize
start_time = Sys.time()
Opt = nlminb( start=Obj$par, objective=Obj$fn, gradient=Obj$gr, control=list("trace"=1) )
  Opt[["final_gradient"]] = Obj$gr( Opt$par )
  Opt[["total_time"]] = Sys.time() - start_time
  Report = Obj$report()
  SD = sdreport( Obj, bias.correct=TRUE )

# One-step-predict
oneStepPredict( Obj, observation.name="Y", method="fullGaussian" )
oneStepPredict( Obj, observation.name="Y", method="oneStepGeneric", data.term.indicator="keep" )
