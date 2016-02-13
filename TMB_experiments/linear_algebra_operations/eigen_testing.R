

setwd( "C:/Users/James.Thorson/Desktop/Project_git/TMB_experiments/linear_algebra_operations/" )

library(TMB)

###################
# Equal distance 2D autoregressive
###################

# Compile
compile( "eigen_testing_V1.cpp" )
dyn.load( dynlib("eigen_testing_V1") )

Params = list( "beta"=0, "rho"=0.8, "sigma2"=0.5 )
Data = list( "c_i"=rep(0,10) )
Obj = MakeADFun( data=Data, parameters=Params, DLL="eigen_testing_V1" )
report = Obj$report()

report$L %*% diag(report$diagD) %*% t(report$L)
report$L %*% solve(report$L)
report$L %*% t(report$L)
