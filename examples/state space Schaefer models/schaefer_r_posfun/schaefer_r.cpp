
 //-----------------------------------------------------
 //  State-Space Schaefer Production model
 //  with posfun()
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
  PARAMETER_VECTOR(logu);
  
  PARAMETER(logSigmaProc); 
  PARAMETER(logSigmaObs);
 
  Type r = exp(logR);
  Type k = exp(logK);
  Type q = exp(logQ);
  
  Type sigmaProc = exp(logSigmaProc);
  Type SigmaObs = exp(logSigmaObs);

  vector<Type> u(n);
  vector<Type> B(n);
  vector<Type> Ihat(n);
  vector<Type> P(n);
 
  for(int t=0; t<n; t++){
  u(t)=exp(logu(t));	  
  }

  Type f = 0.;
  Type fpen = 0.;
  
  // initial condition
  P(0)=u(0)/k;	  

  // process error model
  for(int t=0; t<(n-1); t++){
  B(t+1) = posfun(u(t) + r*u(t)*(Type(1.0)-u(t)/k) - C(t),Type(0.001),fpen); 
  f -= dnorm(log(u[t+1]), log(B(t+1)), sigmaProc, true);
  }
  f += fpen;

  // observation error model
  for(int t=0; t<n; t++){
  Ihat(t) = q*u(t);
  f -= dnorm(log(I(t)), log(Ihat(t)), SigmaObs, true);
  }
  
  // rest of B/k
  for(int t=1; t<n; t++){
  P(t)=u(t)/k;	  
  }
   
  // Penalty on P
  f -= dnorm(P(0), Type(0.8), Type(1), true);
 
      
  ADREPORT(u); // uncertainty  
  ADREPORT(B); // uncertainty
  ADREPORT(Ihat);
    
  REPORT(u);
  REPORT(B);
  REPORT(Ihat);

  REPORT(P);  
  REPORT(sigmaProc);
  REPORT(SigmaObs);
  REPORT(r);
  REPORT(k);
  REPORT(q);
  REPORT(fpen);
     
  return f;
}
