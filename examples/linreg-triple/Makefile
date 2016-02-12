all:
	$(MAKE) linreg.so
	$(MAKE) run

run:
	R CMD BATCH linreg.R
	cat linreg.Rout

linreg.so: linreg.o
	clang++ -dynamiclib -Wl,-headerpad_max_install_names -undefined dynamic_lookup -single_module -multiply_defined suppress -L/Library/Frameworks/R.framework/Resources/lib -L/usr/local/lib -o linreg.so linreg.o /Library/Frameworks/R.framework/Versions/3.2/Resources/library/TMB/libs/libTMBdbg.o -F/Library/Frameworks/R.framework/.. -framework R -Wl,-framework -Wl,CoreFoundation

linreg.o: linreg.cpp
	clang++ -I/Library/Frameworks/R.framework/Resources/include -DNDEBUG -I/Library/Frameworks/R.framework/Versions/3.2/Resources/library/TMB/include -I/Library/Frameworks/R.framework/Versions/3.2/Resources/library/RcppEigen/include -DTMB_SAFEBOUNDS -DLIB_UNLOAD=R_unload_linreg -DWITH_LIBTMB -I/usr/local/include -I/usr/local/include/freetype2 -I/opt/X11/include    -fPIC  -O0 -g -c linreg.cpp -o linreg.o

debug: clean
	R --debugger=lldb

html: readme.html

readme.html: readme.md
	markdown_py $^ > $@

clean:
	rm -f linreg.Rout
	rm -f *.o
	rm -f linreg.so
	rm -f readme.html
	rm -f .RData
	rm -f .Rhistory
