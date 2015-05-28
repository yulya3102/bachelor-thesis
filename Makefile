all: slides

diagram: diagram.dot
	rm diagram.png
	dot -Tpng -o diagram.png diagram.dot

slides: slides.md diagram
	pandoc -V lang=russian -t beamer -s slides.md -o presentation.pdf
