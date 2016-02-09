#include <TMB.hpp>

template<class Type>
Type objective_function<Type>::operator()()
{
 DATA_FACTOR(Sex);
 DATA_VECTOR(Age);
 DATA_VECTOR(Length);
 int n = Length.size();

 // These are the parameters (three are vectors; one is a scalar)
 PARAMETER_VECTOR(Linf);
 PARAMETER_VECTOR(Kappa);
 PARAMETER_VECTOR(t0);
 PARAMETER(LogSigma);
 Type Sigma = exp(LogSigma);
 vector<Type> LengthPred(n);

 // Provide the standard error of Sigma
 ADREPORT(Sigma);

 // Predictions and likelihoods
 for(int i=0;i<n;i++){
  Type Temp = Kappa(Sex(i))*(Age(i)-t0(Sex(i)));
  LengthPred(i) = Linf(Sex(i))*(1.0-exp(-Temp));
  }
 Type nll = -sum(dnorm(Length,LengthPred,Sigma,true));

 // Prediction for sex 1 and age 10
 Type Temp = Kappa(0)*(Type(10)-t0(0));
 Type PredLen10 = Linf(0)*(1.0-exp(-Temp));
 ADREPORT(PredLen10);

 // Predicted growth curve
 matrix<Type>LenPred(2,50);
 for (int Isex=0;Isex<2;Isex++)
  for (int Iage=1;Iage<=50;Iage++)
   {
   Temp = Kappa(Isex)*(Iage*1.0-t0(Isex));
   LenPred(Isex,Iage-1) = Linf(Isex)*(1.0-exp(-Temp));
   }
 REPORT(LenPred);

 return nll;
}
