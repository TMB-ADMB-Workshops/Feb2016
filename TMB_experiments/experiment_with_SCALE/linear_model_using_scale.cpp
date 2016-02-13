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

  // Rescale
  vector<Type> beta_g(n_factors);
  beta_g = b_g * exp(logsigma_g);

  // Probability of random coefficients
  matrix<Type> Cov_gg(n_factors, n_factors);
  Cov_gg.setIdentity();
  MVNORM_t<Type> nll_mvnorm(Cov_gg);
  jnll += SCALE(nll_mvnorm, exp(logsigma_g))( beta_g );

  // Probability of data conditional on fixed and random effect values
  for( int i=0; i<n_data; i++){
    jnll -= dnorm( y_i(i), mu + beta_g(g_i(i)), exp(logsigma_y), true );
  }

  // Reporting
  REPORT( logsigma_y );
  REPORT( logsigma_g );
  return jnll;
}
