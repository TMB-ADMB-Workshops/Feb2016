// Space time
#include <TMB.hpp>
template<class Type>
Type objective_function<Type>::operator() ()
{
  using namespace density;
  
  // Data
  DATA_VECTOR( y_i );
  DATA_FACTOR( g_i );

  // Parameters
  PARAMETER( mu );
  PARAMETER( logsigma_y );
  PARAMETER( logsigma_g );
  PARAMETER_VECTOR( b_g );

  int n_data = y_i.size();
  int n_factors = b_g.size();

  // Objective funcction
  Type jnll = 0;

  // Probability of random coefficients
  matrix<Type> Cov_gg(n_factors, n_factors);
  Cov_gg.setIdentity();
  Cov_gg = exp(2*logsigma_g) * Cov_gg;
  MVNORM_t<Type> nll_mvnorm(Cov_gg);
  jnll += nll_mvnorm( b_g );

  // Probability of data conditional on fixed and random effect values
  for( int i=0; i<n_data; i++){
    jnll -= dnorm( y_i(i), mu + b_g(g_i(i)), exp(logsigma_y), true );
  }

  // Reporting
  REPORT( logsigma_y );
  REPORT( logsigma_g );
  return jnll;
}
