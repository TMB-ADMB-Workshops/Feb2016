
library(TMB)

mu_b = 2
sigma_b = 2
sigma_c = 1

b_g = rnorm(10, mean=mu_b, sd=sigma_b)
g_i = rep(1:10,each=10)
y_i = b_g[g_i] + rnorm(length(g_i), mean=0, sd=sigma_c)

# sanity check
library(lme4)
Lm = lmer( y_i ~ 1 + 1|g_i )
summary(Lm)

# compile both models
compile( "linear_model.cpp" )
compile( "linear_model_using_scale.cpp" )

# Build inputs (same for both models)
Data = list( "g_i"=g_i-1, "y_i"=y_i)
Parameters = list( "mu"=-10, "logsigma_y"=2, "logsigma_g"=2, "b_g"=rep(0,length(unique(g_i))) )
Random = c("b_g")


################
# In TMB, without using scale
# WORKS CORRECTLY
################

# Build object
dyn.load( dynlib("linear_model") )
Obj = MakeADFun(data=Data, parameters=Parameters, random=Random)

# Optimize
Opt = nlminb( start=Obj$par, objective=Obj$fn, gradient=Obj$gr, control=list("trace"=1) )
Report = Obj$report()
exp( unlist(Report[c('logsigma_g','logsigma_y')]) )

################
# In TMB, using scale
# DOES NOT WORK CORRECTLY
################

# Build object
dyn.load( dynlib("linear_model_using_scale") )
Obj = MakeADFun(data=Data, parameters=Parameters, random=Random)

# Optimize
Opt = nlminb( start=Obj$par, objective=Obj$fn, gradient=Obj$gr, control=list("trace"=1) )
Report = Obj$report()
exp( unlist(Report[c('logsigma_g','logsigma_y')]) )

