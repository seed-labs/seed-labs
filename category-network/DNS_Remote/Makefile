
LAB    = DNS_Remote
LABPDF = $(LAB).pdf

all: $(LABPDF)


%.pdf: %.tex
	pdflatex $<
	pdflatex $<


bib: $(LAB)

$(LAB):
	pdflatex $@.tex
	bibtex $@
	pdflatex $@.tex
	pdflatex $@.tex


clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

