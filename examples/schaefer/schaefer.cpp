#include <TMB.hpp>

template<class Type>
Type objective_function<Type>::operator() ()
{
  DATA_VECTOR(C);
  DATA_VECTOR(I);
  int n = C.size();

  PARAMETER(logR);
  PARAMETER(logK);
  PARAMETER(logQ);
  PARAMETER(logSigma);
  Type r = exp(logR);
  Type k = exp(logK);
  Type q = exp(logQ);
  Type sigma = exp(logSigma);
  vector<Type> B(n);
  vector<Type> Ihat(n);
  Type f;

  B(0) = k;
  for(int t=0; t<(n-1); t++)
  {
    B(t+1) = abs(B(t) + r*B(t)*(1-B(t)/k) - C(t));
  }
  Ihat = q*B;
  f = -sum(dnorm(log(I), log(Ihat), sigma, true));

  ADREPORT(log(B)); // uncertainty
  REPORT(B);        // plot
  REPORT(Ihat);     // plot

  return f;
}
