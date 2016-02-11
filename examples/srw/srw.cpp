#include <TMB.hpp>

template<class Type>
Type objective_function<Type>::operator() ()
{
  DATA_VECTOR(observed);

  PARAMETER_VECTOR(population);
  PARAMETER(log_process_error);
  PARAMETER(log_obs_error);
  
  Type process_error=exp(log_process_error);
  Type obs_error=exp(log_obs_error);
  
  int n_obs = observed.size();  // number of observations
  
  Type nll=0; // negative log likelihood
  
  // likelihood for state transitions
  for(int y=1; y<n_obs; y++){
    Type m=population[y-1];
    nll -= dnorm(population(y), m, process_error, true);
  }
  
  // likelihood for observations
  for(int y=0; y<n_obs; y++){
    nll -= dnorm(observed(y), population(y), obs_error, true);
  }
  
  ADREPORT(process_error);
  ADREPORT(obs_error);
  
  return nll;
}
