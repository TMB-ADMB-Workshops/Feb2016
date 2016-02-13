
MakeADFun_windows_debug = function( cpp_name, data, parameters, random=NULL, dir=getwd(), overwrite=FALSE, recompile=TRUE, ... ){

  # Set local working directory
  orig_dir = getwd()
  setwd( dir )
  on.exit( setwd(orig_dir) )

  # Recompile
  if( recompile==TRUE ){
    unlink( dynlib(cpp_name) )
    compile( paste0(cpp_name,".cpp"), "-O1 -g", DLLFLAGS="")
    dyn.load( dynlib(cpp_name) )
    message( "Recompiling .cpp file with appropriate compiler flags" )
  }

  # Get and save inputs
  Other_inputs = list(...)
  All_inputs = list( "data"=data, "parameters"=parameters, "random"=random, "Other_inputs"=Other_inputs )
  save( All_inputs, file="All_inputs.RData")

  # Write file to source
  if( (paste0(cpp_name,".R") %in% list.files()) & overwrite==FALSE ){
    message( "By default, we don't overwrite existing file ",cpp_name,".R")
    Return = "Didn't attempt running"
  }else{
    sink( paste0(cpp_name,".R") )
    cat("
      library( TMB )
      dyn.load( dynlib('",cpp_name,"') )
      setwd('",dir,"')
      load( 'All_inputs.RData' )
      Obj = MakeADFun(data=All_inputs[['data']], parameters=All_inputs[['parameters']], random=All_inputs[['random']], All_inputs[['Other_inputs']])
      save( Obj, file='Obj.RData')
    ",fill=FALSE,sep="")
    sink()

    # Try running
    Bdg_output = gdbsource(paste0(cpp_name,".R"))

    # Sort out outcomes
    if( length(grep("#0",Bdg_output))==0 ){
      Return = MakeADFun(data=All_inputs[['data']], parameters=All_inputs[['parameters']], random=All_inputs[['random']], All_inputs[['Other_inputs']])
      message("Compiled fine, and returning output from MakeADFun")
    }else{
      Return = Bdg_output
      message("Did not compile, and returning output from bdbsource")
      #print( Bdg_output )
    }
  }

  # Return
  return( Return )
}
