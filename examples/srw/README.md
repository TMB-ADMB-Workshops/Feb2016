#Simple Random Walk in TMB
##Premise
You are given a time series of population observations
Can you estimate the population and separate the process and observation errors assuming the population follows a random walk?
##Data Generator
` 
   n.obs <- 35     
   true.process.error <- 0.2     
  true.obs.error <- 0.4     
  true.population <- rep(0,n.obs)     
  true.population[1] <- rnorm(1,0,true.process.error)     
  for (i in 2:n.obs){     
    true.population[i] <- true.population[i-1] + rnorm(1,0,true.process.error)      
  }     
  observed <- round(true.population + rnorm(n.obs,0,true.obs.error), 6)     
`

