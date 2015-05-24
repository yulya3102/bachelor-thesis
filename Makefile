all: report

report: agda-latex
	./waf

agda-latex:
	make -C ..
