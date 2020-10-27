
LAB    = Mitnick_Attack
LABPDF = $(LAB).pdf

COMMONFOLDER = ../../common-files
DEPENDENCE = $(COMMONFOLDER)/container_setup.tex $(COMMONFOLDER)/container_interface.tex


all: $(LABPDF) 


%.pdf: %.tex $(DEPENDENCE)
	pdflatex $<
	pdflatex $<

cp:
	cp $(LABPDF) $(WEB)

clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

