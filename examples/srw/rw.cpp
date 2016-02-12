#include <TMB.hpp>


template<class Type>
Type step(Type x1, Type x2, Type var, Type jnll)
{
  jnll += Type(0.5)*(log(Type(2.0)*Type(3.14)*var) + ((x2-x1)*(x2-x1))/var); 
  return jnll; 
}

template<class Type>
Type obs(Type x2, Type obs, Type yvar, Type yconst, Type jnll)
{
  jnll +=  Type(0.5)*(yconst +  ((x2-log(obs))*(x2-log(obs)))/yvar);
  return jnll; 
}
template<class Type>
Type objective_function<Type>::operator() ()
{
  DATA_IVECTOR(year);
  DATA_VECTOR(biom);
  DATA_VECTOR(cv);
  PARAMETER_VECTOR(predbiom);
  int n = year.size();
  PARAMETER(logSdLam);        // The process error sd (log scale)
  vector <Type> srv_sd(n);
  vector <Type> yvar(n);      // the observation error variances
  vector <Type> yconst(n);      // the observation error variances
  for (int i=0;i<=(n-1);i++)  // convert SD to CVs
  {
    if (cv(i) > 0)
    {
      srv_sd(i) = Type(1.0) + cv(i)*cv(i);
      srv_sd(i) = sqrt(log(srv_sd(i)));
      yvar(i)   = srv_sd(i)*srv_sd(i);
      yconst(i) = log(Type(2.0)*Type(3.14)*yvar(i)); 
    }
    else
    {
      srv_sd(i) = -9;
      yvar(i)   = -9;
      yconst(i) = -9;
    }
  }
  
  //PARAMETER(mu);
  //PARAMETER(logSigma);

  Type var =exp(Type(2.0)*logSdLam);
  Type jnll = 0.0;

  for (int i=1;i<=(n-1);i++)    
  {
    jnll = step(predbiom(i-1),predbiom(i),var, jnll);    // process errors
  }

  for (int j=0;j<=(n-1);j++)
  { 
    if (yvar(j) >0)
    {
      jnll = obs(predbiom(j),biom(j),yvar(j),yconst(j), jnll);    // observation errors 
    }
  }

  //Type f = 0.0;
  //f = -sum(dnorm(biom, mu, exp(logSigma), true));

  REPORT(yvar);
  ADREPORT(predbiom);
  REPORT(biom);
  REPORT(log(biom));
  return jnll;
}

