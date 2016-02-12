Debug _linreg.so_ shared library using lldb.

### Procedure

1. In Terminal shell, type R command to open debug (lldb) command shell

	`$ R --debugger=lldb`

2. In (lldb) command shell, type run to start R shell

	`(lldb) run`

3. In R shell, source *linreg.R* script

	`> source('linreg.R')`

	> *Note* Debug flags __"-O0 -g"__ should be added to function compile parameter in *linreg.R* for symbol information.
	> 
	> `compile("linreg.cpp", flags="-O0 -g")`
	> 

	The output will show error at _file_ and _line_.

	`Assertion failed: (x.size() != y.size()), function operator(), file linreg.cpp, line 20.`

	The R shell will exit and return to the (lldb) shell.

4. In (lldb) command shell, set a breakpoint at file and line where the assertion failed.

	`(lldb) breakpoint set --file linreg.cpp --line 20`

	Repeat steps 2 then 3.

	The run output will point to the breakpoint in the code where it paused.

		   18  	  DATA_VECTOR(x);
		   19  	  DATA_VECTOR(y);
		-> 20  	  assert(x.size() != y.size());
		   21
		   22  	  int n = y.size();
		   23

	For information on lldb, read [tutorial](http://lldb.llvm.org/tutorial.html) on how to use debugger.
