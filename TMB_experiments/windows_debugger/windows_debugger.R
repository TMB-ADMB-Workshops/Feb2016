
setwd( "C:/Users/James.Thorson/Desktop/Project_git/TMB_experiments/windows_debugger" )

######################
# Experiment with debugger
######################

library(TMB)
compile( "problem.cpp", "-O1 -g", DLLFLAGS="")
gdbsource( "problem.R" )

