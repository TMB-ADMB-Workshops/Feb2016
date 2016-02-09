#include <TMB.hpp>
template<class Type>
Type objective_function<Type>::operator() ()
{
				PARAMETER(mu);
				Type nll = pow(Type(42)-mu,2);
				return nll;
}
