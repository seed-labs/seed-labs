
LAB    = Environment_Variable_and_SetUID
LABPDF = $(LAB).pdf
CF     = ../../common-files
DEPEND = $(CF)/header.tex $(CF)/copyright.tex $(CF)/submission.tex

all: $(LABPDF)


%.pdf: %.tex $(DEPEND)
	pdflatex $<
	pdflatex $<

clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

