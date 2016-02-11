 ################################################
 #  State-Space Schaefer Production model
 #  with posfun()
 #
 #  Group project by:
 #  
 #  Yi-Jay Chang
 #  Felipe Carvalho
 #  Jin Gao
 #  Marc Nadon
 #  2/9/2016 9:40:46 PM
 ################################################
  
 setwd("C:\\Users\\Yi-Jay.Chang\\Desktop\\schaefer_r_posfun\\")
 hake <- read.table("schaefer.dat", header=TRUE)
 names(hake) <- c("t", "C", "I")
 n = length(hake[,1])
 
 # compile and load
 library(TMB)
 compile("schaefer_r.cpp")
 dyn.load(dynlib("schaefer_r"))

 # MakeADFun and output
 Random = c("logu")
 parameters <- list(logR=-1.1, logK=8.0, logQ=-7.9, logu = rep(log(5000),n), logSigmaProc=log(0.1), logSigmaObs=log(0.1))
 model <- MakeADFun(data=hake,parameters=parameters,random=Random)
 model$gr(model$par)
 
 fit <- nlminb(model$par,objective=model$fn, gradient=model$gr,control=list("trace"=1))
 model$gr(fit$par)
 
 rep <- model$report()
 SD = summary(sdreport(model))
 print(rep)
 print(SD)
 
 # Plot
 hake$B <- model$report()$B
 hake$Ihat <- model$report()$Ihat

 par(mfrow=c(1,2))

 plot(hake$t,rep$u,ylim=c(0,5000),type="l",lty=2,col=2,ylab="Catch and Biomass",xlab="Year")
 points(hake$t,hake$C,type="l") 
 points(hake$t,rep$u+1.96*SD[30:53,2],type="l",lty=3,col=2)
 points(hake$t,rep$u-1.96*SD[30:53,2],type="l",lty=3,col=2)

 legend("topright", legend = c("Catch", "Biomass"),
 pch = c(NA, NA), lty = c(1, 2), lwd = c(1,1),
 col = c("black","red"),pt.bg = c(NA,NA))

 plot(I~t, hake, ylim=c(0,1.1*max(hake$I)), ylab="Index",xlab="Year")
 lines(Ihat~t, hake)

