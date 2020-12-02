LAB    = VPN
LABPDF = $(LAB).pdf 

CF      = ../../common-files
DEPEND  = $(CF)/header.tex $(CF)/copyright.tex 
DEPEND2 = Demo_Checklist.tex demo.tex

all: $(LABPDF)

%.pdf: %.tex $(DEPEND) $(DEPEND2) 
	pdflatex $<
	pdflatex $<



clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

