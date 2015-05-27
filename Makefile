all: slides diagram

diagram: diagram.dot
	rm diagram.png
	dot -Tpng -o diagram.png diagram.dot

slides: slides.md
	pandoc -V lang=russian -t beamer -s slides.md -o presentation.pdf
