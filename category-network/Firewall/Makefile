

LAB    = Firewall
LABPDF = $(LAB).pdf

COMMONFOLDER = ../../common-files
DEPENDENCE = $(COMMONFOLDER)/container_setup.tex $(COMMONFOLDER)/container_detach_from_192.168.tex


all: $(LABPDF)


%.pdf: %.tex $(DEPENDENCE)
	pdflatex $<
	pdflatex $<

clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~


