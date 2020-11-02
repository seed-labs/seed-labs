

LAB    = Firewall
LABPDF = $(LAB).pdf

COMMONFOLDER = ../../common-files
DEPENDENCE = $(COMMONFOLDER)/container/setup.tex $(COMMONFOLDER)/container/detach_from_interface.tex


all: $(LABPDF)


%.pdf: %.tex $(DEPENDENCE)
	pdflatex $<
	pdflatex $<

clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~


