report: main.pdf

REPORT_SOURCES = \
	Introduction.pd \
	01.pd \
	02-intro.pd \
	../DevCore.lagda \
	../SSA.lagda \
	../NotSSA.lagda \
	../Meta.lagda \
	02-conclusion.pd \
	03-result.pd \
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

