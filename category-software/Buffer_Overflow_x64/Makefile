
LAB    = Buffer_Overflow_x64
LABPDF = $(LAB).pdf

all: $(LABPDF)


%.pdf: %.tex
	pdflatex $<
	pdflatex $<

clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

