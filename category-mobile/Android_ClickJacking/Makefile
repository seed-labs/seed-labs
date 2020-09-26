
LAB    = Android_ClickJacking
LABPDF = $(LAB).pdf


all: $(LABPDF)


%.pdf: %.tex
	pdflatex $<
	pdflatex $<

clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

