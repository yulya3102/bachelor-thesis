all: slides

diagram: diagram.dot
	rm diagram.png
	dot -Tpng -o diagram.png diagram.dot

%.png: %.svg diagram
	convert $< $@

slides: slides.md diagram compcert.png vellvm.png faith.png memory.png ld.png
	pandoc -V lang=russian -t beamer -s slides.md -o presentation.pdf
