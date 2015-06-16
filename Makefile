all: slides

slides: slides.md
	pandoc -V lang=russian -t beamer -s slides.md -o presentation.pdf --template=default.beamer
