
LAB    = DNS_Remote
LABPDF = $(LAB).pdf

COMMONFOLDER = ../../common-files
DEPENDENCE = $(COMMONFOLDER)/container/setup.tex $(COMMONFOLDER)/manual.tex 


all: $(LABPDF)


%.pdf: %.tex $(DEPENDENCE) 
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

