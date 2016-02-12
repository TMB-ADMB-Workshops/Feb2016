all: clean html
	-R CMD BATCH linreg.R
	cat linreg.Rout

debug: clean
	R --debugger=lldb

html: readme.html

readme.html: readme.md
	markdown_py $^ > $@

clean:
	rm -f linreg.Rout
	rm -f linreg.o
	rm -f linreg.so
	rm -f readme.html
	rm -f .RData
	rm -f .Rhistory
