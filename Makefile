all: slides

pre-diagram.png: diagram.dot
	dot -Tpng -o $@ $<

diagram.png: axis.svg pre-diagram.png
	convert $< $@

%.png: %.svg diagram.png
	convert $< $@

slides: slides.md diagram.png compcert.png vellvm.png faith.png memory.png ld.png
	pandoc -V lang=russian -t beamer -s slides.md -o presentation.pdf
