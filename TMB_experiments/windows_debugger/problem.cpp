// Space time
#include <TMB.hpp>
template<class Type>
Type objective_function<Type>::operator() ()
{
  // Data
  DATA_INTEGER( n_data );
  DATA_INTEGER( n_factors );
  DATA_FACTOR( Factor );
  DATA_VECTOR( Y );                

  // Parameters
  PARAMETER( X0 );
  PARAMETER( log_SD0 );
  PARAMETER( log_SDZ );
  PARAMETER_VECTOR( Z );
  
  // Objective funcction
  Type jnll = 0;
  
  // Probability of data conditional on fixed and random effect values
  for( int i=0; i<n_data; i++){
    jnll -= dnorm( Y(i), X0 + Z(Factor(i)), exp(log_SD0), true );
  }
  
  // Probability of random coefficients
  for( int i=0; i<n_factors; i++){
    jnll -= dnorm( Z(i), Type(0.0), exp(log_SDZ), true );
  }
  
  // Reporting
  Type SDZ = exp(log_SDZ);
  Type SD0 = exp(log_SD0);
  ADREPORT( SDZ );
  REPORT( SDZ );
  ADREPORT( SD0 );
  REPORT( SD0 );
  ADREPORT( Z );
  REPORT( Z );
  ADREPORT( X0 );
  REPORT( X0 );
  
  // bias-correction testing
  Type MeanZ = Z.sum() / Z.size();
  Type SampleVarZ = ( (Z-MeanZ) * (Z-MeanZ) ).sum();
  Type SampleSDZ = pow( SampleVarZ + 1e-20, 0.5);
  REPORT( SampleVarZ );
  REPORT( SampleSDZ );  
  ADREPORT( SampleVarZ );
  ADREPORT( SampleSDZ );  
  

  return jnll;
}
