#include <TMB.hpp>

template<class Type>
Type objective_function<Type>::operator() ()
{
  DATA_INTEGER(minAge);         
  DATA_INTEGER(maxAge);         
  DATA_INTEGER(minYear);        
  DATA_INTEGER(maxYear);        
  DATA_ARRAY(catchNo);        
  DATA_ARRAY(stockMeanWeight);
  DATA_ARRAY(propMature);     
  DATA_ARRAY(M);              
  DATA_INTEGER(minAgeS);        
  DATA_INTEGER(maxAgeS);        
  DATA_INTEGER(minYearS);       
  DATA_INTEGER(maxYearS);       
  DATA_SCALAR(surveyTime);     
  DATA_ARRAY(Q1);  

  PARAMETER_VECTOR(logN1Y);
  PARAMETER_VECTOR(logN1A);
  PARAMETER_VECTOR(logFY);
  PARAMETER_VECTOR(logFA);
  PARAMETER_VECTOR(logVarLogCatch);
  PARAMETER_VECTOR(logQ);
  PARAMETER(logVarLogSurvey);  

  int na=maxAge-minAge+1;
  int ny=maxYear-minYear+1;
  int nas=maxAgeS-minAgeS+1;
  int nys=maxYearS-minYearS+1;

  // setup F
  matrix<Type> F(ny,na);
  for(int y=0; y<ny; ++y){
    for(int a=0; a<na; ++a){
      F(y,a)=exp(logFY(y))*exp(logFA(a));
    }
  }
  // setup logN
  matrix<Type> logN(ny,na);
  for(int a=0; a<na; ++a){
    logN(0,a)=logN1Y(a);
  } 
  for(int y=1; y<ny; ++y){
    logN(y,0)=logN1A(y-1);
    for(int a=1; a<na; ++a){
      logN(y,a)=logN(y-1,a-1)-F(y-1,a-1)-M(y-1,a-1);
      if(a==(na-1)){
        logN(y,a)=log(exp(logN(y,a))+exp(logN(y,a-1)-F(y-1,a)-M(y-1,a)));
      }
    }
  }
  matrix<Type> predLogC(ny,na);
  for(int y=0; y<ny; ++y){
    for(int a=0; a<na; ++a){
      predLogC(y,a)=log(F(y,a))-log(F(y,a)+M(y,a))+log(Type(1.0)-exp(-F(y,a)-M(y,a)))+logN(y,a);
    }
  }

  Type ans=0; 
  for(int y=0; y<ny; ++y){
    for(int a=0; a<na; ++a){
      if(a==0){
        ans+= -dnorm(log(catchNo(y,a)),predLogC(y,a),exp(Type(0.5)*logVarLogCatch(0)),true);
      }else{
        ans+= -dnorm(log(catchNo(y,a)),predLogC(y,a),exp(Type(0.5)*logVarLogCatch(1)),true);
      }
    }
  }

  matrix<Type> predLogS(nys,nas);
  for(int y=0; y<nys; ++y){
    for(int a=0; a<nas; ++a){
			int sa        = a+(minAgeS-minAge);
			int sy        = y+(minYearS-minYear);
			predLogS(y,a) = logQ(a)-(F(sy,sa)+M(sy,sa))*surveyTime+logN(sy,sa);
			ans          += -dnorm(log(Q1(y,a)),predLogS(y,a),exp(Type(0.5)*logVarLogSurvey),true);
    }
  }

  vector<Type> ssb(ny);
  ssb.setZero();
  for(int y=0; y<=ny; ++y){
    for(int a=0; a<na; ++a){
    	std::cout<<y<<" "<<a<<" "<<"\n";
      ssb(y)+=exp(logN(y,a))*stockMeanWeight(y,a)*propMature(y,a);
    }
  }

  ADREPORT(ssb);
  return ans;
}
