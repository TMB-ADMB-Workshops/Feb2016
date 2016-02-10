#include <TMB.hpp>


template<class Type>
Type posfun(Type x, Type eps, Type &pen)
{
  if ( x >= eps ){
    return x;
  } else {
    pen += Type(0.01) * pow(x-eps,2);
    return eps/(Type(2.0)-x/eps);
  }
}

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
  Type fpen = 0;
  Type tmpB;
  B(0) = k;
  for(int t=0; t<(n-1); t++)
  {
    // B(t+1) = abs(B(t) + r*B(t)*(1-B(t)/k) - C(t));
    tmpB = B(t) + r*B(t)*(1-B(t)/k) - C(t);
    B(t+1) = posfun(tmpB,Type(0.01),fpen);
  }
  Ihat = q*B;
  f = -sum(dnorm(log(I), log(Ihat), sigma, true));
  f += fpen;

  ADREPORT(log(B)); // uncertainty
  REPORT(B);        // plot
  REPORT(Ihat);     // plot
  REPORT(fpen);

  return f;
}




// dvariable posfun(const dvariable&x,const double eps,dvariable& pen)
//     {
//       if (x>=eps) {
//         return x;
//       } else {
//         pen+=.01*square(x-eps);
//         return eps/(2-x/eps);
// } }


