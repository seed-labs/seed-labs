
LAB    = Smart_Contract
LABPDF = $(LAB).pdf



all: $(LABPDF)


%.pdf: %.tex ../common-files/emulator.tex ../common-files/etherview.tex 
	pdflatex $<
	pdflatex $<


clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

