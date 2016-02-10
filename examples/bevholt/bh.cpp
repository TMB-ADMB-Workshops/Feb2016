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

	vector<Type>    x = S * exp(u);
	vector<Type>    y = a * x / ( Type(1.0) + b * x );
	vector<Type> epsi = log(R) - log(y);
	Type nll = 0;
	nll -= sum(dnorm(epsi,Type(0.0),sig,true));
	nll -= sum(dnorm(u,Type(0.0),tau,true));


	REPORT(x);
	REPORT(y);
	REPORT(epsi);
	ADREPORT(y);

	return nll;
}

