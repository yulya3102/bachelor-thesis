all: slides

algebra.png: algebra.dot
	dot -Tpng $< $@

slides: slides.md algebra.png
	pandoc -V lang=russian -t beamer -s slides.md -o presentation.pdf --template=default.beamer
