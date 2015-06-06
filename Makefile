all: slides

diagram.png: diagram.dot
	dot -Tpng -o diagram.png diagram.dot

slides: slides.md diagram.png
	pandoc -V lang=russian -t beamer -s slides.md -o presentation.pdf
