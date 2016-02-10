setwd("F:\\")
TheD <- read.csv("Ex1.Dat")
print(TheD)

data <- list()
data$Sex <- TheD[,1]-1
data$Age <- TheD[,2]
data$Length <- TheD[,3]

param <- list()
param$Linf <- c(100,100)
param$Kappa <- c(0.1,0.1)
param$t0 <- c(0,0)
param$LogSigma <- 0.1

require(TMB)
compile("ex1.cpp")
dyn.load(dynlib("ex1"))

# Model #1
obj1 <- MakeADFun(data, param, DLL="ex1",map=list(t0=factor(c(NA,NA))),silent=T)
opt1 <- nlminb(obj1$par, obj1$fn, obj1$gr)
AIC1 <- 2*opt1$objective + 2*length(opt1$par)
summary(sdreport(obj1))

# Model #2
obj2 <- MakeADFun(data, param, DLL="ex1",map=list(Kappa=factor(c(1,1))))
opt2 <- nlminb(obj2$par, obj2$fn, obj2$gr)
AIC2 <- 2*opt2$objective + 2*length(opt2$par)
summary(sdreport(obj2))

# Model #3
obj3 <- MakeADFun(data, param, DLL="ex1",map=list(Linf=factor(c(1,1)),Kappa=factor(c(1,1)),t0=factor(c(1,1))))
opt3 <- nlminb(obj3$par, obj3$fn, obj3$gr)
AIC3 <- 2*opt2$objective + 2*length(opt3$par)
summary(sdreport(obj3))

# Report the AIC values
cat(AIC1,AIC2,AIC3,"\n")

# Plot the best fir (sadly model 3)
par(mfrow=c(2,2))
for (Isex in 1:2)
 {
  plot(TheD[data$Sex==(Isex-1),2],TheD[data$Sex==(Isex-1),3],pch=16,xlab="Age",ylab="Length") 
  lines(1:50,obj3$report()$LenPred[Isex,])
 }  


