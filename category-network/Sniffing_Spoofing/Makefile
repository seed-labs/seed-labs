
LAB    = Sniffing_Spoofing
LABPDF = $(LAB).pdf

COMMONFOLDER = ../../common-files
DEPENDENCE = $(COMMONFOLDER)/container_setup.tex $(COMMONFOLDER)/container_interface.tex

all: $(LABPDF)


%.pdf: %.tex $(DEPENDENCE)
	pdflatex $<
	pdflatex $<

clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

