
LAB    = Crypto_MD5_Collision
LABPDF = $(LAB).pdf

CF     = ../../common-files
DEPEND  = $(CF)/header.tex $(CF)/copyright.tex $(CF)/submission.tex

all: $(LABPDF)

%.pdf: %.tex $(DEPEND)
	pdflatex $<
	pdflatex $<

bib: $(LAB)

$(LAB):
	pdflatex $@.tex
	bibtex $@
	pdflatex $@.tex
	pdflatex $@.tex


clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

