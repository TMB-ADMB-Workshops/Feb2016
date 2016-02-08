DATA_SECTION
	init_int nobs
	init_vector x(1,nobs)
PARAMETER_SECTION
  init_number mu;
  init_number logSigma;
	objective_function_value  f;
PROCEDURE_SECTION
  f = dnorm(x,mu,exp(logSigma));
