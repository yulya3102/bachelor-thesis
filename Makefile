all: slides

pre-diagram.png: diagram.dot
	dot -Tpng -o $@ $<

diagram.png: axis.svg pre-diagram.png
	convert $< $@

faith-axis.svg: axis.svg
	sed 's/pre-diagram.png/pre-faith-diagram.png/' $< > $@

faith-diagram.dot: diagram.dot
	sed '/subgraph cluster_ld {/a \ edge [ color = red ]' $< > $@

pre-faith-diagram.png: faith-diagram.dot
	dot -Tpng -o $@ $<

faith-diagram.png: faith-axis.svg pre-faith-diagram.png
	convert $< $@

faith.png: faith.svg faith-diagram.png
	convert $< $@

%.png: %.svg diagram.png
	convert $< $@

slides: slides.md diagram.png idealworld.png idealcompiler.png compcert.png vellvm.png faith.png memory.png ld.png
	pandoc -V lang=russian -t beamer -s slides.md -o presentation.pdf --template=default.beamer
