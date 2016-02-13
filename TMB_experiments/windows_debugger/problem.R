
setwd( "C:/Users/James.Thorson/Desktop/Project_git/TMB_experiments/windows_debugger" )

#####################
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

Data = list( "n_data"=length(Y)+1, "n_factors"=length(unique(Factor)), "Factor"=Factor-1, "Y"=Y)
Parameters = list( "X0"=-10, "log_SD0"=2, "log_SDZ"=2, "Z"=rep(0,Data$n_factor) )
Random = c("Z")

dyn.load( dynlib("problem") )
Obj = MakeADFun(data=Data, parameters=Parameters, random=Random)

