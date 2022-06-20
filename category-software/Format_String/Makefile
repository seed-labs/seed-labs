
LAB    = Format_String
LABPDF = $(LAB).pdf
CF     = ../../common-files
DEPEND = $(CF)/header.tex $(CF)/copyright.tex $(CF)/submission.tex $(CF)/guidelines/shellcode.tex

all: $(LABPDF)

%.pdf: %.tex $(DEPEND)
	pdflatex $<
	pdflatex $<

clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

