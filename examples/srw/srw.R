require(TMB)
require(Hmisc)

# compile cpp code and load dll
compile("simple_rand_walk.cpp")
dyn.load(dynlib("simple_rand_walk"))

# create new data
create.new.data <- FALSE
if (create.new.data){
  n.obs <- 35
  true.process.error <- 0.2
  true.obs.error <- 0.4
  true.population <- rep(0,n.obs)
  true.population[1] <- rnorm(1,0,true.process.error)
  for (i in 2:n.obs){
    true.population[i] <- true.population[i-1] + rnorm(1,0,true.process.error) 
  }
  observed <- round(true.population + rnorm(n.obs,0,true.obs.error), 6)
  write.table(cbind(observed,true.population),file="new.observed.dat",col.names=c("observed","true_population"),row.names=FALSE)
}

# read data and true population from file
data <- read.table("observed.dat", header=TRUE)
observed <- data$observed
true.population <- data$true_population
n.obs <- length(observed)

# set up data and parameters
dat <- list(
  observed=observed
)

parameters <- list(
  population=rep(0,n.obs),
  log_process_error=0,
  log_obs_error=0
)

# now estimate population, process error, and observation error
obj <- MakeADFun(dat,parameters,DLL="simple_rand_walk", random=c("population"), silent=TRUE)
opt <- nlminb(obj$par, obj$fn, obj$gr, control=list(iter.max=1000,eval.max=1000))
rep <- sdreport(obj)
srep <- summary(sdreport(obj))
print(srep)

# get results in a format for plots
est.pop <- srep[rownames(srep) == "population",]
est.process.error <- as.vector(round(srep[rownames(srep) == "process_error",],3))
est.obs.error <- as.vector(round(srep[rownames(srep) == "obs_error",],3))
ep <- est.pop[,1]
hi <- est.pop[,1]+2*est.pop[,2]
lo <- est.pop[,1]-2*est.pop[,2]
my.range <- range(c(observed,hi,lo))

# make a series of pretty plots
#windows(record=T)  # Windows users will want to uncomment this line
od <- paste0(my.dir,"\\plots\\")
saveplots <- FALSE

# observed data only
plot(1:n.obs,observed,pch=16,ylim=my.range,xlab="Year",ylab="Population")
legend('topleft',legend=c("obs"),pch=c(16),col=c("black"))
if(saveplots) savePlot(paste0(od,"obs.png"), type='png')

# observed and true population
plot(1:n.obs,observed,pch=16,ylim=my.range,xlab="Year",ylab="Population")
points(1:n.obs,true.population,col="blue")
legend('topleft',legend=c("obs","true"),pch=c(16,1),col=c("black","blue"))
if(saveplots) savePlot(paste0(od,"obs_true.png"), type='png')

# now with the estimated
plot(1:n.obs,observed,pch=16,ylim=my.range,xlab="Year",ylab="Population")
points(1:n.obs,true.population,col="blue")
errbar(1:n.obs,ep,hi,lo,pch=3,col="red",errbar.col="red",add=TRUE)
legend('topleft',legend=c("obs","true","est"),pch=c(16,1,3),col=c("black","blue","red"))
title(main=paste("process error   =",true.process.error,", est=",est.process.error[1]," (",est.process.error[2],") ",
               "\nobservation error=",true.obs.error,", est=",est.obs.error[1]," (",est.obs.error[2],") ", sep=""), outer=F)
if(saveplots) savePlot(paste0(od,"obs_true_est.png"), type='png')



