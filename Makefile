all: report

report: agda
	./waf

agda:
	cd .. && agda --latex --latex-dir report/ch_Development/ --allow-unsolved-metas Instructions.lagda
	mv ch_Development/Instructions.tex ch_Development/Instructions.latex
