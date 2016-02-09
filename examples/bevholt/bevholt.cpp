#include <TMB.hpp>

template<class Type>
Type objective_function<Type>::operator() ()
{
  DATA_VECTOR(R);
  DATA_VECTOR(S);
  int n = R.size();

  PARAMETER(logRmax);
  PARAMETER(logS50);
  PARAMETER(logSigma);
  Type Rmax = exp(logRmax);
  Type S50 = exp(logS50);
  Type sigma = exp(logSigma);
  vector<Type> Rhat(n);

  Type neglogL = 0;

  Rhat = Rmax * S / (S + S50);
  ADREPORT(Rhat);
  neglogL = -sum(dnorm(R, Rhat, sigma, true));

  return neglogL;
}
