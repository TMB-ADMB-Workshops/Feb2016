#include <TMB.hpp>
template<class Type>
Type objective_function<Type>::operator() ()
{
  DATA_VECTOR(wtage);
  DATA_VECTOR(wtcv);

  PARAMETER(b0);
  PARAMETER(b1);
  PARAMETER(logSigma);
  // matrix<Type> yfit(n);
  // int nrows = wtage.dim[0];
  // int ncols = wtage.dim[1];

  Type neglogL = 0.0;

  // yfit = b0 + b1*x;
  // neglogL = -sum(dnorm(y, yfit, exp(logSigma), true));

  // JIM THORSON JUST ROCK'N TMB
  
  return neglogL;
  // std::cout << b0<<" "<<b1<<"\n ";
}
  /*
	init_int styr
  init_int endyr
  init_int age_st
  init_int age_end
  int nages;
  !! nages = age_end - age_st +1;
  init_matrix wt_obs(styr,endyr,age_st,age_end)
  init_matrix sd_obs(styr,endyr,age_st,age_end)
	int ret
 LOCAL_CALCS
  ret=0;
  if (ad_comm::argc > 1)
  {
    int on=0;
    if ( (on=option_match(ad_comm::argc,ad_comm::argv,"-ret"))>-1)
    {
      if (on>ad_comm::argc-2 | ad_comm::argv[on+1][0] == '-')
      {
        cerr << "Invalid number of iseed arguements, command line option -ret ignored" << endl;
      }
      else
      {
        ret = atoi(ad_comm::argv[on+1]);
      }
    }
		endyr= endyr - ret;
  }
  cout <<endyr<<endl;//exit(1);
 END_CALCS
INITIALIZATION_SECTION

PARAMETER_SECTION
  matrix wt_pre(styr,endyr+3,age_st,age_end)
  init_bounded_number log_sd_coh(-5,10,3);
  init_bounded_number log_sd_yr(-5,10,4);
  init_vector mnwt(age_st,age_end);
  sdreport_number sig_coh
  sdreport_number sig_yr
  sdreport_vector wt_last(age_st,age_end);
  sdreport_vector wt_cur(age_st,age_end);
  sdreport_vector wt_next(age_st,age_end);
  sdreport_vector wt_yraf(age_st,age_end);


  // init_bounded_vector coh_eff(styr-nages-age_st+1,endyr-age_st,-5,5,2);
  // init_bounded_vector yr_eff(styr,endyr,-5,5,3);
  random_effects_vector coh_eff(styr-nages-age_st+1,endyr-age_st+3,3);
  random_effects_vector yr_eff(styr,endyr+3,3);

  objective_function_value nll;

  PROCEDURE_SECTION
  dvariable sigma_coh = (mfexp(log_sd_coh));
  dvariable sigma_yr = (mfexp(log_sd_yr ));
  for (int i=styr;i<=endyr+3;i++)
  {
    wt_pre(i) = mnwt*exp(sigma_yr*yr_eff(i));
    for (int j=age_st;j<=age_end;j++)
    {
      wt_pre(i,j) *= exp(sigma_coh*coh_eff(i-j));
      if (i <= endyr)
        nll += square(wt_obs(i,j)-wt_pre(i,j))/(2.*square(sd_obs(i,j)));
    }
  }
  nll += 0.5*norm2(coh_eff);
	nll += 0.5*norm2( yr_eff);
  if (sd_phase())
  {
    wt_last = wt_pre(endyr)  *exp(sigma_coh*sigma_coh/2. + sigma_yr*sigma_yr/2.);
    wt_cur  = wt_pre(endyr+1)*exp(sigma_coh*sigma_coh/2. + sigma_yr*sigma_yr/2.);;
    wt_next = wt_pre(endyr+2)*exp(sigma_coh*sigma_coh/2. + sigma_yr*sigma_yr/2.);;
    wt_yraf = wt_pre(endyr+3)*exp(sigma_coh*sigma_coh/2. + sigma_yr*sigma_yr/2.);;
    sig_coh = exp(log_sd_coh);
    sig_yr  = exp(log_sd_yr );
  }

  REPORT_SECTION
 report << wt_pre<<endl;
  */
