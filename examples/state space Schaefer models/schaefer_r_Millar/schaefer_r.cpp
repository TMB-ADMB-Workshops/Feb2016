 //-----------------------------------------------------
 //  State-Space Schaefer Production model
 //  with Meyer & Millar formulation
 //
 //  Group project by:
 //  
 //  Yi-Jay Chang
 //  Felipe Carvalho
 //  Jin Gao
 //  Marc Nadon
 //  2/9/2016 9:40:46 PM
 //-----------------------------------------------------

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
  
  // randon effect
  PARAMETER_VECTOR(P_dev);
  
  PARAMETER(logSigmaProc); 
  PARAMETER(logSigmaObs);
 
  Type r = exp(logR);
  Type k = exp(logK);
  Type q = exp(logQ);
  
  Type sigmaProc = exp(logSigmaProc);
  Type SigmaObs = exp(logSigmaObs);

  vector<Type> P(n);
  vector<Type> B(n);  
  vector<Type> Ihat(n);
  
  Type fpen = 0.;
  Type f = 0.;

  // initial condition
  P(0)=exp(P_dev(0));
 
  // process error model
  for(int t=1; t<n; t++){
  P(t)=(P(t-1)+r*P(t-1)*(1-P(t-1))-C(t-1)/k)*exp(P_dev(t));
  P(t)=posfun(P(t),Type(.001),fpen);
  f -= dnorm(P_dev(t),Type(0.), sigmaProc, true);
  }
   
  // observation error model
  for(int t=0; t<n; t++){
  Ihat(t) = q*P(t)*k;
  B(t)=P(t)*k;
  f -= dnorm(log(I(t)), log(Ihat(t)), SigmaObs, true);
  }
  
  // posfun() Penalty 
  f += fpen;
 
  // Penalty on P
  // f -= dnorm(P(0), Type(0.8), Type(1), true);
 
    
  ADREPORT(B); // uncertainty  
  ADREPORT(P); // uncertainty    
  ADREPORT(P_dev); // uncertainty    
  ADREPORT(Ihat);

    
  REPORT(B);
  REPORT(P);
  REPORT(Ihat);
  REPORT(P_dev);  
  REPORT(sigmaProc);
  REPORT(SigmaObs);
  REPORT(r);
  REPORT(k);
  REPORT(q);
   
  return f;
}
