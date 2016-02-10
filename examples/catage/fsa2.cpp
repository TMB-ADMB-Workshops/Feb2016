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
  matrix<Type> F(na,ny);
  for(int a=0; a<na; ++a){
    for(int y=0; y<ny; ++y){
      F(a,y)=exp(logFY(y))*exp(logFA(a));
    }
  }
  // setup logN
  matrix<Type> logN(na,ny);
  for(int a=0; a<na; ++a){
    logN(a,0)=logN1Y(a);
  } 
  for(int y=1; y<ny; ++y){
    logN(0,y)=logN1A(y-1);
    for(int a=1; a<na; ++a){
      logN(a,y)=logN(a-1,y-1)-F(a-1,y-1)-M(a-1,y-1);
      if(a==(na-1)){
        logN(a,y)=log(exp(logN(a,y))+exp(logN(a,y-1)-F(a,y-1)-M(a,y-1)));
      }
    }
  }
  matrix<Type> predLogC(na,ny);
  for(int a=0; a<na; ++a){
    for(int y=0; y<ny; ++y){
      predLogC(a,y)=log(F(a,y))-log(F(a,y)+M(a,y))+log(Type(1.0)-exp(-F(a,y)-M(a,y)))+logN(a,y);
    }
  }

  Type ans=0; 
  for(int a=0; a<na; ++a){
    for(int y=0; y<ny; ++y){
      if(a==0){
        ans+= -dnorm(log(catchNo(a,y)),predLogC(a,y),exp(Type(0.5)*logVarLogCatch(0)),true);
      }else{
        ans+= -dnorm(log(catchNo(a,y)),predLogC(a,y),exp(Type(0.5)*logVarLogCatch(1)),true);
      }
    }
  }

  matrix<Type> predLogS(nas,nys);
  for(int a=0; a<nas; ++a){
    for(int y=0; y<nys; ++y){
      int sa=a+(minAgeS-minAge);
      int sy=y+(minYearS-minYear);
      predLogS(a,y)=logQ(a)-(F(sa,sy)+M(sa,sy))*surveyTime+logN(sa,sy);
      ans+= -dnorm(log(Q1(a,y)),predLogS(a,y),exp(Type(0.5)*logVarLogSurvey),true);
    }
  }

  vector<Type> ssb(ny);
  ssb.setZero();
  for(int y=0; y<ny; ++y){
    for(int a=0; a<na; ++a){
      ssb(y)+=exp(logN(a,y))*stockMeanWeight(a,y)*propMature(a,y);
    }
  }

  ADREPORT(ssb);
  return ans;
}
