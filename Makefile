all: report

report: agda
	./waf

AGDA = SSA NotSSAInstructions Assembler

agda:
	@for lagda in $(AGDA) ; do \
		cd .. && agda --latex --latex-dir report/ch_Development/ --allow-unsolved-metas $$lagda.lagda; \
		cd -; \
		mv ch_Development/$$lagda.tex ch_Development/$$lagda.latex; \
	done
