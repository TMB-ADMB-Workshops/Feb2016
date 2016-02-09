#include <TMB.hpp>


template<class Type>
bool isNA(Type x){
  return R_IsNA(asDouble(x));
}

template<class Type>
bool isFinite(Type x){
  return R_finite(asDouble(x));
}






template<class Type>
Type objective_function<Type>::operator() ()
{
	// DATA SECTION
	DATA_VECTOR(x);		 		// log annual escapement.
	DATA_VECTOR(tot_harvest); 	// total harvest (sum over sectors)
	DATA_ARRAY(i_count);       // weir or aerial count index.
	// DATA_MATRIX(aerial); 		// peak aerial count (year, tributary)
	DATA_ARRAY(wcpue);  		// weekly test fishery cpue (year,week)
	DATA_ARRAY(in_river);		// in river mark-recapture data.

	// PARAMETER SECTION
	PARAMETER(mu);
	PARAMETER(sigma);
	PARAMETER_VECTOR(log_escapement);
	PARAMETER_VECTOR(log_q);
	PARAMETER_VECTOR(log_sig_i);
	

	int nyrs = tot_harvest.size();
	int nobs = i_count.dim(1);
	vector<Type> Et = exp(log_escapement);
	vector<Type> q  = exp(log_q);
	vector<Type> Ct(nyrs);
	matrix<Type> ihat(nyrs,nobs);

	Type objfun = 0;
	Type nll_count = 0;
	Type nll_river = 0;
	for (int i = 0; i < nyrs; ++i)
	{
		
		// negative loglikelihood for count obs.
		for (int j = 0; j < nobs; ++j)
		{
			if( !isNA(i_count(i,j)) )
			{
				Type obs = log(i_count(i,j));
				Type pre = log(q(j) * Et(i));
				Type sig = exp(log_sig_i(j));
				nll_count -= dnorm(obs,pre,sig,true);
				
			}
		}

		// negative loglikeilhood for Inriver MR estimates
		if( !isNA(in_river(i,0)) )
		{
			Type obs = log(in_river(i,0));
			Type pre = log(Et(i)+tot_harvest(i));
			Type sig = sqrt(1.0+in_river(i,1)/(in_river(i,0)*in_river(i,0)));
			nll_river -= dnorm(obs,pre,sig,true);
		}
	}

	std::cout<<nll_river<<"\n";

	Type f;
	f = -sum(dnorm(x,mu,sigma,true));
	// f = -sum(dnbinom(x,mu,sigma,TRUE));

	ADREPORT(sigma);
	REPORT(sigma);

	objfun = nll_count + nll_river;
	return objfun;

}
//



template<class Type>
Type arrival_model()
{
	
}

