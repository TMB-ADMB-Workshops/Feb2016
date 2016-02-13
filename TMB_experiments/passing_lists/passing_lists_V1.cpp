
#include <TMB.hpp>

using namespace Eigen;
using namespace tmbutils;

/* List of sparse matrices */
template<class Type>
struct LOSM_t : vector<SparseMatrix<Type> > {
  LOSM_t(SEXP x){  /* x = List passed from R */
    (*this).resize(LENGTH(x));
    for(int i=0; i<LENGTH(x); i++){
      SEXP sm = VECTOR_ELT(x, i);
      if(!isValidSparseMatrix(sm))
            error("Not a sparse matrix");
      (*this)(i) = asSparseMatrix<Type>(sm);
    }
  }
};

template<class Type>
Type objective_function<Type>::operator() ()
{
  // Data
  DATA_STRUCT( LOSM, LOSM_t);
  DATA_VECTOR( c_i );

  // Parameters
  PARAMETER( beta );
  SparseMatrix<Type> LOSM_0 = LOSM(0);
  REPORT( LOSM_0 );

  // Probability of data conditional on random effects
  Type jnll = 0;
  for( int i=0; i<c_i.size(); i++){
    jnll -= dnorm( c_i(i), beta, Type(1.0), true );
  }

  return jnll;
}
