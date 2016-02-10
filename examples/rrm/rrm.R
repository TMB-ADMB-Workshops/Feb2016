


# --------------------------------------------------------------------------- #
# --------------------------------------------------------------------------- #
# Grab Kuskokwim Chinook data and tailor it to my needs.
data_file  <- 'Kusko_estimates2015_Dec22.csv'
kusko.data <- read.csv(data_file,header=T, na.string='NA')

# Modifications
Year <- as.vector(kusko.data$Year)
nyr  <- length(Year)

# Harvest
harvest <- as.matrix(kusko.data[substr(names(kusko.data),1,2)=="H."])
tot.harvest <- rowSums(harvest,na.rm=TRUE)

# Weir counts
weir <- as.matrix(kusko.data[substr(names(kusko.data),1,2)=="w."])

# Aerial counts
aerial <- as.matrix(kusko.data[substr(names(kusko.data),1,2)=="a."])

# In.river
in.river <- as.matrix(kusko.data[substr(names(kusko.data),1,3)=="In."])


# Number of scaling coefficients.
nq <- dim(weir)[2] + dim(aerial)[2]
i_count <- cbind(weir,aerial)

# Test fishery weekly cpue
wcpue <- as.matrix(kusko.data[substr(names(kusko.data),1,3)=="rpw"])

# --------------------------------------------------------------------------- #
# --------------------------------------------------------------------------- #





# --------------------------------------------------------------------------- #
# --------------------------------------------------------------------------- #
# RUN RECONSTRUCTION MODEL.  
# AUTHORS: Steven Martell, Hamachan, Haflinger
# 	- Use a run-timing model to predict arrivals (A_t) and departures (D_t)
# 	- N_t = E_y \left[ \int_{t=0}^{t} f(\mu_d,\sigma_m)dt 
#           -\int_{t=0}^{t-s}g(\mu_d,\sigma_m)dt \right]
# 	- Bethel test fishery starts on June 1, each year and runs through Aug 24.
#   - June 1 corresponds to week 22.
# 
# 	- For the beta distribution:
# 		b = [(E(x)-1)(E(x)^2-E(x)+V(x))]V(x)
# 		a = (E(x)b)/(1-E(x))
# 	TODO LIST:
#  [ ] Build Simulation Model.
#  [ ] Run simulation testing.
# 
# --------------------------------------------------------------------------- #
# --------------------------------------------------------------------------- #
# library(lubridate)
# Mean Escapement
meanRunSize <- 100
days        <- seq(1,365,by=1) / 365

# 
# Mean Arrival date (day of year) 
mu.aday <- lubridate::yday(as.Date("1978-06-16")) / 365

# Stdev in Arrival date (days)
sd.aday <- 35 / 365

# Survey life (s in days)
s <- 42 /365

# Arrival model parameters
mu  = mu.aday
var = sd.aday*sd.aday
b = ( (mu-1)*(mu^2-mu+var) )/var
a = ( mu * b )/(1-mu)

# Cumulative arrival model
avec <- pbeta(days,a,b)

# Cumulative death model
dvec <- pbeta(days-s,a,b)

# Daily run size
nt   <- meanRunSize * (avec - dvec)

# sample dates for geting mean cpue
idate <- seq(lubridate::yday("1970-06-01"),by=7,length=10)

# test fishery cpue
set.seed(3424)
sig.epsilon <- 0.12
epsilon     <- rnorm(length(idate),0,sig.epsilon)
it          <- nt[idate]*exp(epsilon)












# rrm.R
# R-script for run reconstruction model (rrm)

n = 100
x = rnorm(n,mean=0,sd=1)


library(TMB)
compile("rrm.cpp",flags=" -O0")
dyn.load(dynlib("rrm"))

print(weir)
# weir[is.na(weir)]<-0
inputData <- list(x=x,tot_harvest=tot.harvest,
                  i_count=i_count,wcpue=wcpue,
                  in_river=in.river)

params <- list(mu=0,sigma=1,log_escapement=rep(0,length=nyr),
               log_q=rep(0,length=nq),log_sig_i=rep(0,length=nq))

# Construct an R object that represents the C++ function
# f = MakeADFun(inputData,parameters=params)#,random=c("mu"))
f = MakeADFun(inputData,parameters=params,DLL="rrm")#,random=c("mu"))

# The objective function value
f$fn()

# The gradient (first order derivatives)
f$gr()

# The Hessian (second order derivatives)
f$he()

# Likelihood maximization
fit <- nlminb(f$par,f$fn,f$gr,lower=c(-10.0,0.0),upper=c(10.0,10.0))



