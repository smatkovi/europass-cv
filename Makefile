# makefile for dvips
file=templates/template_en
.PHONY: clean all

clean:
	@echo "+$@"
	rm -f *.pdf *.log *.out *.synctex.gz *.aux
templete-cv: $(file)_cv.tex
	@echo "+$@"
	@pdflatex -synctex=1 -interaction=nonstopmode $(file)_cv.tex
	@pdflatex -synctex=1 -interaction=nonstopmode $(file)_cv.tex

template-cover: $(file)_cover.tex
	@echo "+$@"
	@pdflatex -synctex=1 -interaction=nonstopmode $(file)_cover.tex
	@pdflatex -synctex=1 -interaction=nonstopmode $(file)_cover.tex

test: clean template-cv template-cover