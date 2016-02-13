
File = "C:/Users/James.Thorson/Desktop/Project_git/TMB_experiments/windows_debugger"
setwd( File )
source( "MakeADFun_windows_debug.R" )

#####################
# Simulate data
######################

Factor = rep( 1:10, each=10)
Z = rnorm( length(unique(Factor)), mean=0, sd=1)

X0 = 0

Y = Z[Factor] + X0 + rnorm( length(Factor), mean=0, sd=1)

######################
# Experiment with debugger
######################

library(TMB)
cpp_name = "problem"
#compile( paste0(cpp_name,".cpp"), "-O1 -g", DLLFLAGS="")
compile( paste0(cpp_name,".cpp") )

data = list( "n_data"=length(Y), "n_factors"=length(unique(Factor)), "Factor"=Factor-1, "Y"=Y)
parameters = list( "X0"=-10, "log_SD0"=2, "log_SDZ"=2, "Z"=rep(0,data$n_factor) )
random = c("Z")

#dyn.load( dynlib(cpp_name) )
Output = MakeADFun_windows_debug( data=data, cpp_name=cpp_name, dir=File, parameters=parameters, random=random, overwrite=TRUE )
