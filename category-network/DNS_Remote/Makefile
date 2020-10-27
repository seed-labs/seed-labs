
LAB    = DNS_Remote
LABPDF = $(LAB).pdf

COMMONFOLDER = ../../common-files
DEPENDENCE1 = $(COMMONFOLDER)/container_setup.tex $(COMMONFOLDER)/manual.tex 
DEPENDENCE2 = ../DNS_Common/summary_of_config.tex ../DNS_Common/setup_testing.tex


all: $(LABPDF)


%.pdf: %.tex $(DEPENDENCE1) $(DEPENDENCE2)
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

