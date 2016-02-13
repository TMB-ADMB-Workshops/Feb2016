
#include <TMB.hpp>
/** \brief Matrix exponential: matrix of arbitrary dimension. */
template <class scalartype, int dim>
struct matexp_mod{
  typedef Matrix<scalartype,dim,dim> matrix;
  typedef Matrix<std::complex<scalartype> ,dim,dim> cmatrix;
  typedef Matrix<std::complex<scalartype> ,dim,1> cvector;
  cmatrix V;
  cmatrix iV;
  cvector lambda;
  EigenSolver< matrix > eigensolver;
  matexp(){};
  matexp(matrix A_){
    eigensolver.compute(A_);
    V=eigensolver.eigenvectors();
    lambda=eigensolver.eigenvalues();
    iV=V.inverse();
  }
  matrix operator()(scalartype t){
    cmatrix tmp;
    tmp.setZero();
    matrix ans;
    for(int i=0;i<dim;i++)tmp(i,i)=exp(lambda(i)*t);
    //tmp=V*tmp*iV;
    tmp=tmp.operator*(iV);
    tmp=V.operator*(tmp);

    for(int i=0;i<dim;i++)
      for(int j=0;j<dim;j++)
	ans(i,j)=std::real(tmp(i,j));
    return ans;
  }
};

template<class Type>
Type objective_function<Type>::operator() ()
{
  // Data
  DATA_VECTOR( c_i );

  // Parameters
  PARAMETER( beta );
  PARAMETER( rho );
  PARAMETER( sigma2 );

  // Probability of random effects
  int n_y = c_i.size();
  matrix<Type> Q_yy( n_y, n_y );
  Q_yy.setZero();
  for(int y=0; y<n_y; y++) Q_yy(y,y) = (1+pow(rho,2))/sigma2;
  for(int y=1; y<n_y; y++){
    Q_yy(y-1,y) = -1 * rho/sigma2;
    Q_yy(y,y-1) = 1 * rho/sigma2;
  }
  REPORT( Q_yy )

  // Elementary
  Eigen::SparseMatrix<Type> Qsparse_yy = asSparseMatrix( Q_yy );
  Type Q_yy_determinant = Q_yy.determinant();
  REPORT( Qsparse_yy );
  REPORT( Q_yy_determinant );

  // LDLT operations
  // https://github.com/kaskr/adcomp/blob/master/TMB/inst/include/Eigen/src/Cholesky/LDLT.h
  matrix<Type> L = Q_yy.ldlt().matrixL();
  vector<Type> diagD = Q_yy.ldlt().vectorD();
  vector<Type> V = Q_yy.jacobiSvd().computeV();
  REPORT( L );
  REPORT( diagD );
  REPORT( V );

  // Eigenvalues
  // EXAMPLE AT: https://github.com/kaskr/adcomp/blob/master/TMB/inst/include/tmbutils/matexp.hpp
  //Eigen::EigenSolver< Eigen::SparseMatrix<Type> > eigensolver;
  //eigensolver.compute( Qsparse_yy, true );
  Eigen::EigenSolver< matrix<Type> > eigensolver;
  Eigen::Matrix< Type, Eigen::Dynamic, Eigen::Dynamic > Tmp_yy = Q_yy;
  //Eigen::EigenSolver< matrix<Type> > eigensolver( Tmp_yy );
  //eigensolver.compute( Q_yy );
  //matrix<Type> V = eigensolver.eigenvectors();
  //vector<Type> lambda = eigensolver.eigenvalues();
  //Q_yy.doComputeEigenvectors();
  vector< std::complex< Type > > eigenvalues_Q_yy = Q_yy.eigenvalues();
  vector< Type > real_eigenvalues_Q_yy = eigenvalues_Q_yy.real();
  vector< Type > imag_eigenvalues_Q_yy = eigenvalues_Q_yy.imag();
  REPORT( real_eigenvalues_Q_yy );
  REPORT( imag_eigenvalues_Q_yy );

  // Eigenvectors
  // http://eigen.tuxfamily.org/dox-devel/classEigen_1_1EigenSolver.html#a8c287af80cfd71517094b75dcad2a31b
  using namespace Eigen;
  // WORKS
  MatrixXf A = MatrixXf::Random(4,4);
  EigenSolver<MatrixXf> es(A);
  //es.compute(A);
  es.eigenvectors();
  // TESTING
  EigenSolver< matrix<Type> > es_type( );
  //MatrixXf A = MatrixXf::Random(4,4);
  //es.compute(Q_yy);
  //es.eigenvectors();

  // QR decomposition

  // Schur decomposition
  // https://github.com/kaskr/adcomp/blob/master/TMB/inst/include/Eigen/src/Eigenvalues/RealSchur.h
  Eigen::RealSchur< matrix<Type> > realschur;
  //realschur.compute( Q_yy, true );

  // SVD experiments
  Q_yy.jacobiSvd();
  Q_yy.jacobiSvd().computeV();

  // Kroenecker
  matrix<Type> QQ_yy = kronecker(Q_yy, Q_yy);
  Eigen::SparseMatrix<Type> QQsparse_yy = asSparseMatrix( QQ_yy );
  REPORT( QQ_yy );
  REPORT( QQsparse_yy );
  //REPORT( QQsparse_yy );

  // Probability of data conditional on random effects
  Type Total_Abundance = 0;
  Type jnll = 0;
  for( int i=0; i<n_y; i++){
    jnll -= dnorm( c_i(i), beta, Type(1.0), true );
  }

  return jnll;
}
