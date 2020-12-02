
LAB     = Crypto_Hash_Length_Ext
LABPDF  = $(LAB).pdf

CF     = ../../common-files
DEPEND  = $(CF)/header.tex $(CF)/copyright.tex $(CF)/submission.tex
DEPEND2 = $(CF)/container/setup.tex


all: $(LABPDF)

%.pdf: %.tex $(DEPEND) $(DEPEND2)
	pdflatex $<
	pdflatex $<

clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

