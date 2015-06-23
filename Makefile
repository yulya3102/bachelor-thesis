all: slides report

.PHONY: slides report images

images:
	make -C images

slides: images
	make -C slides

report: images
	make -C report
