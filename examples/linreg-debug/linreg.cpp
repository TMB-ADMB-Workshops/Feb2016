#include <TMB.hpp>
#include <signal.h>
#ifdef NDEBUG
  #undef NDEBUG
#endif
#include <cassert>

extern "C" void myabort(int signal)
{
  std::cerr << "Error(signal" << signal << "): linbcg aborted.\n";  
}

template<class Type>
Type objective_function<Type>::operator() ()
{
  signal(SIGABRT, &myabort);  //overide abort in assert.

  DATA_VECTOR(x);
  DATA_VECTOR(y);
  assert(x.size() != y.size());

  int n = y.size();

  PARAMETER(b0);
  PARAMETER(b1);
  PARAMETER(logSigma);
  vector<Type> yfit(n);

  Type neglogL = 0.0;

  yfit = b0 + b1*x;
  neglogL = -sum(dnorm(y, yfit, exp(logSigma), true));

  // JIM THORSON JUST ROCK'N TMB
  std::cout << b0<<" "<<b1<<"\n ";

  return neglogL;
}
