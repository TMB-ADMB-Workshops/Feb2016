#include <TMB.hpp>

template<class Type>
Type objective_function<Type>::operator() ()
{
  DATA_VECTOR(R);
  DATA_VECTOR(S);
  int n = R.size();

  PARAMETER(loga);
  PARAMETER(logb);
  PARAMETER(logSigma);
  Type a = exp(loga);
  Type b = exp(logb);
  Type sigma = exp(logSigma);
  vector<Type> Rhat(n);

  Type neglogL = 0;

  Rhat = a * S * exp(-b*S);
  ADREPORT(Rhat);
  neglogL = -sum(dnorm(R, Rhat, sigma, true));

  return neglogL;
}
