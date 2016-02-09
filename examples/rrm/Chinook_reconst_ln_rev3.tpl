//==============================================================================================================
//  Chinook_reconst_ln_rev2.TPL 
//  This model is the latest version of the Kuksokwim Run Reconstruction model based on Escapement.  
//  Variance estimated separately for each project  
//==============================================================================================================

//===============================================================================================================
// 1.0  Data Entry 
//===============================================================================================================
DATA_SECTION
  init_int ny;                       // number of years in the model 
  init_int nweek;                        // number of weeks in catch - effort model
  init_vector tcatch(1,ny);          // Sum of all Catches
  init_vector minesc(1,ny);            // Sum of all escapements
  init_vector minrun(1,ny);          // Sum of all counts (minimum observable run size)
// Read Inriver data  
  init_vector inrvr(1,ny);     // Observations for Inriver Estimates
  init_vector inrvrsd(1,ny);   // Observations for standard deviation  
// Read Weir data   
  init_matrix w_esc(1,6,1,ny);
// Read Aerial data  
  init_matrix a_esc(1,14,1,ny);
// Read Weekly Commercial  data  
  init_matrix testf(1,nweek,1,ny);   // proportion of run by week and year 
  init_matrix ccat(1,nweek,1,ny);    // harvest by week and year 
  init_matrix ceff(1,nweek,1,ny);     // effort by week and year 
  init_matrix creg(1,nweek,1,ny);
// Read contorl parameters 
  init_number cvw;
  init_number cva;
  init_number cvf;
  init_vector wlike(1,6);
  init_vector alike(1,14);
  init_vector flike(1,3);
  
  !! cout << "Data Section Completed" << endl;

//===============================================================================================================
// 2.0  Define parameters 
//===============================================================================================================
PARAMETER_SECTION
  init_bounded_vector log_esc(1,ny,10.0,13.5,1);  // log drainage-wise escapement
  init_bounded_vector log_wesc(1,6,2.0,7.0,1);       // log transformed slope for weir model
  init_bounded_vector log_aesc(1,14,1.0,10.0,1);       // log transformed slope for aerial model
  init_bounded_vector log_rwesc(1,6,-10.0,1.0,2);       // log transformed sd for weir model
  init_bounded_vector log_raesc(1,14,-10.0,1.0,2);       // log transformed sd for aerial model  
  init_bounded_vector log_q(1,3,-12.0,-9.0,1);        // log transformed cpue  model1
  init_bounded_vector log_rq(1,3,-10.0,2.0,2);        // log transformed sd cpue model1

  //  Transformed numbers 
  
  vector wesc(1,6);       // slope for weir model
  vector aesc(1,14);       // slope for aerial model
  vector rwesc(1,6);       // sd for weir model
  vector raesc(1,14);       // sd for aerial model
  vector q(1,3);        // slope catchability for catch 
  vector rq(1,3);        // sd catchability for catch
  
  vector tot_run(1,ny);                    // vector of total run
  vector esc(1,ny);                       // vector of escapement obtained from Total run - Total Catch
  number fpen;  
  vector tfw(1,6);   // Likelihood for weir model
  vector tfa(1,14);  // likelihood for aerial model
  vector tfc(1,3);          // likelihood for catch model
  number tfr;          // likelihood for inriver model
  matrix cpue(1,3,1,ny);
  matrix testp(1,3,1,ny);  
  objective_function_value f

//===============================================================================================================
// 3.0  Initialization
//===============================================================================================================

INITIALIZATION_SECTION
  log_wesc   5.0;        // log transformed slope for Kwethluk weir model
  log_aesc  4.0;       // log transformed slope for Kwethluk aerial model
  log_rwesc   1.0;        // log transformed slope for Kwethluk weir model
  log_raesc  1.0;       // log transformed slope for Kwethluk aerial model
  log_esc  11.5;      // log transformed esc  
  log_q   -10.0;      // log transformed catchability coefficient 1;
  log_rq   1.0;      // log transformed catchability coefficient 1;

PRELIMINARY_CALCS_SECTION
   int i,j,k;
  for (i=1;i<=ny;i++)
  {
  for (j=1;j<=nweek;j++) 
        {
    // Unrestricted mesh catch	
    if(creg(j,i)==1) 
            {
		   cpue(1,i) += ccat(j,i)/ceff(j,i);
		   testp(1,i) += testf(j,i);	
            }
    // Restricted mesh catch            
    if(creg(j,i)==2) 
            {
 		   cpue(2,i) += ccat(j,i)/ceff(j,i);
		   testp(2,i) += testf(j,i);           
		   }
    // Monofilament mesh catch  
    if(creg(j,i)==3 or creg(j,i)==5) 
            {
		   cpue(3,i) += ccat(j,i)/ceff(j,i);
		   testp(3,i) += testf(j,i);
			}	
        }
  }  
  
  
// =========================================================================================================================
PROCEDURE_SECTION

  f=0.0;
  q=exp(log_q);             // slope for catchability
  rq=exp(log_rq);           // SD for catchability  
  wesc=exp(log_wesc);       // slope for weir model
  aesc=exp(log_aesc);       // slope for aerial model
  rwesc=exp(log_rwesc);       // SD for weir model
  raesc=exp(log_raesc);       // SD for aerial model  
  esc=exp(log_esc);     // escapement 

  evaluate_the_objective_function();
  
RUNTIME_SECTION
  maximum_function_evaluations 200000000
  convergence_criteria 1.e-20
  
//===========================================================================================================================

//===========================================================================================================================
FUNCTION evaluate_the_objective_function
  int i,j,k;
  dvariable var1, var2, var3, var4, var5;
  tfw = 0.0;              // initialilze to 0
  tfa = 0.0;              // initialilze to 0
  tfc = 0.0;              // initialilze to 0
  tfr = 0.0;              // initialilze to 0
  
//===  Inriver model calculation =============================================================================      
  tot_run = esc + tcatch;
  for (i=1;i<=ny;i++)
   {
   if(inrvr(i) >0)
     {
//     tfr += square(inrvr(i)-tot_run(i))/square(inrvrsd(i));  //Noraml likelihood
     tfr += 0.5*square(log(inrvr(i))-log(tot_run(i)))/log(square(inrvrsd(i)/inrvr(i))+1);  //log-noraml likelihood	 
     }   
//============= Weir likelihood Calculation ================================================================   
  for(j=1;j<=6;j++)
	{
	if(w_esc(j,i)>0) 
     {
		var1 = log(square(cvw)+1)+square(rwesc(j));
        tfw(j) += wlike(j)*(log(sqrt(var1))+0.5*square(log(w_esc(j,i))-log(esc(i)/wesc(j)))/var1);  
     } 
   }
//===  Aerial survey based likelihood calculation ============================================================================
  for(k=1;k<=14;k++)
   {
  if(a_esc(k,i)>0) 
     {
        var2 = log(square(cva)+1)+square(raesc(k));
		tfa(k) += alike(k)*(log(sqrt(var2))+0.5*square(log(a_esc(k,i))-log(esc(i)/aesc(k)))/var2);  
     } 
   }   
//===  Calculate Predicted Effort =============================================================================   
	if(cpue(1,i)>0)  
	{
	var3 = log(square(cvf)+1)+square(rq(1));	
	tfc(1) += flike(1)*(log(sqrt(var3))+0.5*square(log(cpue(1,i)/testp(1,i))-log(q(1)*tot_run(i)))/var3);
	}
	if(cpue(2,i)>0)  
	{
	var4 = log(square(cvf)+1)+square(rq(2));		
	tfc(2) += flike(2)*(log(sqrt(var4))+0.5*square(log(cpue(2,i)/testp(2,i))-log(q(2)*tot_run(i)))/var4);
	}
	if(cpue(3,i)>0)  
	{
	var5 = log(square(cvf)+1)+square(rq(3));		
	tfc(3) += flike(3)*(log(sqrt(var5))+0.5*square(log(cpue(3,i)/testp(3,i))-log(q(3)*tot_run(i)))/var5);
	}
  }           
// Sum all likelihood ===========================================================================================

  f = tfr+sum(tfw)+sum(tfa)+sum(tfc);    

// ==========================================================================

REPORT_SECTION
// ============================================================================
    report <<"Total Run"<< endl;
    report << tot_run << endl;
    report << "Escapement" << endl;
    report << esc <<endl;
    report << "f" << endl;
    report << f << endl;
    report << "tfw" << endl;
    report << tfw << endl;
    report << "tfa" << endl;
    report << tfa << endl;
    report << "tfc" << endl;
    report << tfc << endl;
    report << "tfr" << endl;
    report << tfr << endl;
    
//===============================================================================================================
// Globals section 
//===============================================================================================================

GLOBALS_SECTION
  #include <math.h>
  #include <time.h>
  #include <statsLib.h>
  #include <df1b2fun.h>
  #include <adrndeff.h>

  time_t start,finish;
  long hour,minute,second;
  double elapsed_time;
  
TOP_OF_MAIN_SECTION
  arrmblsize = 100000000;
  gradient_structure::set_MAX_NVAR_OFFSET(30000000);
  gradient_structure::set_GRADSTACK_BUFFER_SIZE(3000000); 
  gradient_structure::set_CMPDIF_BUFFER_SIZE(100000000);
  time(&start);
  
FINAL_SECTION
 // Output summary stuff
  time(&finish);
  elapsed_time = difftime(finish,start);
  hour = long(elapsed_time)/3600;
  minute = long(elapsed_time)%3600/60;
  second = (long(elapsed_time)%3600)%60;
  cout << endl << endl << "Starting time: " << ctime(&start);
  cout << "Finishing time: " << ctime(&finish);
  cout << "This run took: " << hour << " hours, " << minute << " minutes, " << second << " seconds." << endl << endl;
  