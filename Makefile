all: slides.md
	pandoc -V lang=russian -t beamer -s slides.md -o slides.pdf
