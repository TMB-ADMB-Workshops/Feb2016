#include <TMB.hpp>
#include <signal.h>

//Include the source file
#include "triple.cpp"

#ifdef NDEBUG
  #undef NDEBUG
#endif
#include <cassert>

template<class Type>
Type objective_function<Type>::operator() ()
{
  DATA_VECTOR(x);
  DATA_VECTOR(y);

  int n = y.size();

  PARAMETER(b0);
  PARAMETER(b1);
  PARAMETER(logSigma);
  vector<Type> yfit(n);

  Type neglogL = 0.0;

  //Call triple function
  yfit = triple(b0) + b1*x;
  neglogL = -sum(dnorm(y, yfit, exp(logSigma), true));

  // JIM THORSON JUST ROCK'N TMB
  std::cout << b0<<" "<<b1<<"\n ";

  return neglogL;
}
