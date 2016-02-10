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
  PARAMETER_VECTOR(FF);
  Type r = exp(logR);
  Type k = exp(logK);
  Type q = exp(logQ);
  Type sigma = exp(logSigma);
  int n1 = 0;
  n1 = n + 1;
  vector<Type> B(n1);
  vector<Type> Ihat(n);
  vector<Type> Chat(n);
  vector<Type> ExpOut(n);
  Type f;
  B(0) = k;
  for(int t=0; t<n; t++)
  {
    Type Expl = 1.0/(1.0+exp(-FF(t)));
    B(t+1) = B(t) + r*B(t)*(1-B(t)/k) - Expl*B(t);
    Chat(t) = Expl*B(t);
    ExpOut(t) = Expl;
    Ihat(t) = q*B(t);
  }
  f = -sum(dnorm(log(C), log(Chat), Type(0.05), true));
  f -= sum(dnorm(log(I), log(Ihat), sigma, true));

  ADREPORT(log(B)); // uncertainty
  REPORT(f);        // plot
  REPORT(B);        // plot
  REPORT(Chat);        // plot
  REPORT(ExpOut);        // plot
  REPORT(Ihat);     // plot

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


