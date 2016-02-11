my.dir <- "C:\\Users\\chris.legault\\Documents\\Working\\Rstuff\\TMB\\TMB_class_Seattle_2016\\examples\\srw"
setwd(my.dir)
od <- paste0(my.dir,"\\plots\\")
saveplots <- TRUE

#install.packages("Hmisc")
require(TMB)
require(Hmisc)

# compile cpp code and load dll
compile("srw.cpp")
dyn.load(dynlib("srw"))

# simulation settings
nloops <- 100
n.obs <- 35
true.process.error.vals <- c(0.1,0.3,0.5)
true.obs.error.vals <- c(0.1,0.3,0.5)
ncases <- length(true.process.error.vals)*length(true.obs.error.vals)
res <- matrix(NA, nrow=ncases*nloops, ncol=8)

# loop through the errors
icount <- 0
case <- 0

for (ii in 1:length(true.process.error.vals)){
  true.process.error <- true.process.error.vals[ii]
  for (jj in 1:length(true.obs.error.vals)){
    true.obs.error <- true.obs.error.vals[jj]
    case <- case + 1
    for (iloop in 1:nloops){
      icount <- icount + 1
      true.population <- rep(0,n.obs)
      true.population[1] <- rnorm(1,0,true.process.error)
      for (i in 2:n.obs){
        true.population[i] <- true.population[i-1] + rnorm(1,0,true.process.error) 
      }
      observed <- round(true.population + rnorm(n.obs,0,true.obs.error), 6)

      dat <- list(
        observed=observed
      )
      parameters <- list(
        population=rep(0,n.obs),
        log_process_error=0,
        log_obs_error=0
      )

      obj <- MakeADFun(dat,parameters,DLL="srw", random=c("population"), silent=TRUE)
      opt <- nlminb(obj$par, obj$fn, obj$gr, control=list(iter.max=1000,eval.max=1000))
      rep <- sdreport(obj)
      srep <- summary(sdreport(obj))
      est.prc.err <- as.vector(round(srep[rownames(srep) == "process_error",],5))
      est.obs.err <- as.vector(round(srep[rownames(srep) == "obs_error",],5))
      res[icount,] <- c(case,true.process.error,true.obs.error,iloop,est.prc.err,est.obs.err)
    }
  }
}

test.in <- function(vec){
  within <- 1
  if (is.na(sum(vec[5:8]))) within <- 0
  else{
    if (vec[2] < (vec[5] - 2 * vec[6])) within <- 0
    if (vec[2] > (vec[5] + 2 * vec[6])) within <- 0
    if (vec[3] < (vec[7] - 2 * vec[8])) within <- 0
    if (vec[3] > (vec[7] + 2 * vec[8])) within <- 0
  }
  return(within)
}

test.fail <- function(vec){
  fail <- 0
  if (vec[5] <= 0.001) fail <- 1
  if (vec[7] <= 0.001) fail <- 1
  return(fail)
}

my.col <- rainbow(ncases)
my.x <- range(res[,5], na.rm=T)
my.y <- range(res[,7], na.rm=T)
graphics.off()
windows(record=T)  
for (icase in 1:ncases){
  cres <- res[res[,1] == icase,]
  plot(cres[,5],cres[,7],col=my.col[icase],xlab="Process Error",ylab="Observation Error",xlim=my.x,ylim=my.y)
  abline(v=cres[1,2],lty=2)
  abline(h=cres[1,3],lty=3)
  prop.in <- 100 * sum(apply(cres, 1, FUN=test.in)) / nloops
  prop.fail <- 100 * sum(apply(cres, 1, FUN=test.fail)) / nloops
  title(main=paste("Case ",icase," (",prop.in,"% true within CI, ",prop.fail,"% fail)", sep=""),outer=F)
  if(saveplots) savePlot(paste0(od,"case",icase,".png"), type='png')
}

