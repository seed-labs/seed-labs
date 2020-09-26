LABNAME = Crypto_Hash_Length_Ext
LABPDF  = $(LABNAME).pdf


$(LABNAME).pdf: $(LABNAME).tex
	pdflatex $(LABNAME).tex
	pdflatex $(LABNAME).tex

bib:
	pdflatex $(LABNAME).tex
	bibtex   $(LABNAME)
	pdflatex $(LABNAME).tex
	pdflatex $(LABNAME).tex

clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

