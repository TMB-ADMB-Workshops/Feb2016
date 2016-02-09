// bh.cpp
#include <TMB.hpp>

template <class Type>
Type objective_function<Type>::operator()()
{
	// DATA
	DATA_VECTOR(R)
	DATA_VECTOR(S)

	// PARAMETERS
	PARAMETER(log_a);
	PARAMETER(log_b);
	PARAMETER(log_sig);
	PARAMETER(log_tau);
	PARAMETER_VECTOR(u);

	Type a = exp(log_a);
	Type b = exp(log_b);
	Type sig = exp(log_sig);
	Type tau = exp(log_tau);

	vector<Type>    X = S * exp(u * tau);
	vector<Type> rhat = a * X / ( Type(1.0) + b * X );
	Type nll = 0;
	nll -= sum(dnorm(log(R),log(rhat),sig,true));
	nll -= sum(dnorm(u,Type(0.0),Type(1.0),true));


	REPORT(rhat);
	REPORT(X);

	return nll;
}

