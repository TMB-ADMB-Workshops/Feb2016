### TMB help sources

Compiled at the TMB training course, Seattle, Feb. 2016.

### Technical paper describing the package

Kristensen, K. et al. 2015. TMB: Automatic differentiation and Laplace approximation. Submitted to the Journal of Statistical Software.

*Abstract*

TMB is an open source R package that enables quick implementation of complex nonlinear random effect (latent variable) models in a manner similar to the established AD Model Builder package (ADMB, admb-project.org) (Fournier, Skaug, Ancheta, Ianelli, Magnusson, Maunder, Nielsen, and Sibert 2011). In addition, it offers easy access to parallel computations. The user defines the joint likelihood for the data and the random effects as a C++ template function, while all the other operations are done in R; e.g., reading in the data. The package evaluates and maximizes the Laplace approximation of the marginal likelihood where the random effects are automatically integrated out. This approximation, and its derivatives, are obtained using automatic differentiation (up to order three) of the joint likelihood. The computations are designed to be fast for problems with many random effects (≈ 106) and parameters (≈ 103). Computation times using ADMB and TMB are compared on a suite of examples ranging from simple models to large spatial models where the random effects are a Gaussian random field. Speedups ranging from 1.5 to about 100 are obtained with increasing gains for large problems.

[Download the PDF (slow link; takes ~1 min)](http://arxiv.org/pdf/1509.00660.pdf)

### Introductory tutorials

#### PowerPoint from Andre Punt 

A dozen slides that concisely explain how to prepare the matching R script and C++ program, run them, and view the results on the R side by placing REPORT and ADREPORT statements on the C++ side and using the easily confused sdreport(model) and model\$report() statements on the R side. [Link to the .ppt file (click on "View raw" to open)](https://github.com/TMB-ADMB-Workshops/Feb2016/blob/master/examples/andre/AndreLecture.ppt)

#### TMB Wiki

The TMB Wiki (https://github.com/kaskr/adcomp/wiki) contains a variety of resources, including a tutorial similar to Andre's PowerPoint that covers the basics (https://github.com/kaskr/adcomp/wiki/Tutorial) and a FAQ (https://github.com/kaskr/adcomp/wiki/FAQ) and code snippets (https://github.com/kaskr/adcomp/wiki/Code--snippets), both dealing mostly with matters that will be of interest to users that have got past the basics.

### Examples

#### TMB repository on GitHub

The TMB repository (https://github.com/kaskr/adcomp) has a link to a number of .R and corresonding .cpp files at: (https://github.com/kaskr/adcomp/tree/master/tmb_examples)

#### Examples from the February 2016 Seattle workshop

 (https://github.com/TMB-ADMB-Workshops/Feb2016/tree/master/examples)

### TMB syntax

#### Data types as declared in the C++ program

On the C++ side, the macros DATA_SCALAR(name), DATA_VECTOR(name), DATA_ARRAY(name) and so on, and the corresponding PARAMETER_ macros read the data and parameters passed in from the R script. Be aware that the ARRAY types are used for matrix algebra operations, while the ARRAY types are used for element-wise operations. Local variables on the C++ side are all declared as class "Type", e.g. "vector<Type> coeff(20);" and "Type neglogl = 0.0;". A list of macros, constructors, and operations is posted at
(https://github.com/kaskr/adcomp/blob/master/TMB/inst/template.cpp).

### Technical documentation

#### R functions

Details on the arguments and return values of the R funcions that make up the TMB package, including MakeADFun(), precompile(), compile(), mcmc(), mcmc.nuts(), and so on. Not for beginners.  

#### C++ functions

Highly technical Doxygen-generated reference document for the C++ working parts of TMB. Not for beginners, nor most other people.

### Miscellany

The "TMB Documentation" page at (http://kaskr.github.io/adcomp/modules.html)
has a variety of brief introductory information.

(www.admb-project.org/developers/tmb/tmb_cpp.pdf)




