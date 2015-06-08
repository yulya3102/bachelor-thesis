report: main.pdf

REPORT = Introduction.latex \
         ch_First/chapter.latex \
         ch_Development/chapter.latex \
         ch_Development/sec_Core/section.latex \
         agda-latex/DevCore.latex \
         ch_Development/sec_SSA/section.latex \
         agda-latex/SSA.latex \
         ch_Development/sec_SSA/problems.latex \
         ch_Development/sec_Diffs.latex \
         agda-latex/NotSSA.latex \
         ch_Development/sec_Meta/section.latex \
         agda-latex/Meta.latex \
         ch_Development/sec_Meta/problems.latex \
         ch_Development/sec_Conclusion.latex \
         ch_Result/chapter.latex \
         agda-latex/Functions.latex \
         Conclusion.latex \
         Licensing.latex

%.latex: %.pd
	pandoc \
		-r markdown-fancy_lists \
		-w latex \
		--natbib --bibliography=bib.bib \
		-R -S --latex-engine=xelatex \
		--listings --chapters \
		-o $@ $<

agda-latex/%.pd: agda-latex/%.tex
	mv $< $@

agda-latex/%.tex: ../%.lagda
	make -C .. $(patsubst agda-latex/%,%,$(@))

main.latex: $(REPORT)
	pandoc \
		-r latex -w latex \
		--toc --chapters -R \
		--template=template.latex \
		-o $@ \
		$(REPORT)

main.pdf: main.latex
	xelatex main.latex
	bibtex main
	xelatex main.latex
