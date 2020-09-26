LAB    = VPN
LABPDF = $(LAB).pdf 

all: VPN.pdf 


%.pdf: %.tex Demo_Checklist.tex
	pdflatex $<
	pdflatex $<



clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

