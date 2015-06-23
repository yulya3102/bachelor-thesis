report: main.pdf

AGDA_SOURCES = ../agda

REPORT_SOURCES = \
	Introduction.pd \
	01.pd \
	02-intro.pd \
	$(AGDA_SOURCES)/DevCore.lagda \
	$(AGDA_SOURCES)/SSA.lagda \
	$(AGDA_SOURCES)/NotSSA.lagda \
	$(AGDA_SOURCES)/Meta.lagda \
	02-conclusion.pd \
	03-result.pd \
	$(AGDA_SOURCES)/Functions.lagda \
	Conclusion.pd

REPORT_AGDA_TRANSLATED = $(patsubst $(AGDA_SOURCES)/%.lagda,$(AGDA_SOURCES)/%.latex,$(REPORT_SOURCES))
REPORT = $(patsubst %.pd,%.latex,$(REPORT_AGDA_TRANSLATED))

%.latex: %.pd
	pandoc \
		-r markdown-fancy_lists \
		-w latex \
		--natbib --bibliography=bib.bib \
		-R -S --latex-engine=xelatex \
		--listings --chapters \
		-o $@ $<

$(AGDA_SOURCES)/%.pd: $(AGDA_SOURCES)/%.tex
	mv $< $@

$(AGDA_SOURCES)/%.tex: $(AGDA_SOURCES)/%.lagda
	make -C $(AGDA_SOURCES) $(patsubst $(AGDA_SOURCES)/%,%,$(@))

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

