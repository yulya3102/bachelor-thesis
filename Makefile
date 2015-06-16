report: main.pdf

REPORT_SOURCES = \
	Introduction.pd \
	ch_First/chapter.pd \
	ch_Development/chapter.latex \
	../DevCore.lagda \
	ch_Development/sec_SSA/section.pd \
	../SSA.lagda \
	ch_Development/sec_SSA/problems.pd \
	../NotSSA.lagda \
	../Meta.lagda \
	ch_Development/sec_Conclusion.pd \
	ch_Result/chapter.pd \
	../Functions.lagda \
	Conclusion.pd

REPORT_AGDA_TRANSLATED = $(patsubst ../%.lagda,agda-latex/%.latex,$(REPORT_SOURCES))
REPORT = $(patsubst %.pd,%.latex,$(REPORT_AGDA_TRANSLATED))

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
	xelatex main.latex

