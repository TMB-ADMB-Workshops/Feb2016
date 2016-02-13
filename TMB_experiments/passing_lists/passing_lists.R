

setwd( "C:/Users/James.Thorson/Desktop/Project_git/TMB_experiments/passing_lists/" )

library(TMB)

###################
# Equal distance 2D autoregressive
###################

library(INLA)
Loc = cbind( runif(10), runif(10))
Mesh = inla.mesh.create( Loc )
Spde = inla.spde2.matern(Mesh,alpha=2)

# Compile
compile( "passing_lists_V1.cpp" )
dyn.load( dynlib("passing_lists_V1") )

Params = list( "beta"=0 )
Data = list( "c_i"=rep(0,10), "LOSM"=Spde$param.inla[c('M0','M1','M2')] )
Obj = MakeADFun( data=Data, parameters=Params, DLL="passing_lists_V1" )
report = Obj$report()

report$L %*% diag(report$diagD) %*% t(report$L)
report$L %*% solve(report$L)
report$L %*% t(report$L)
