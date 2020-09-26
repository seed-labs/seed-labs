LABNAME = DNS_Rebinding
LABPDF = $(LABNAME).pdf

$(LABNAME).pdf: $(LABNAME).tex
	pdflatex $(LABNAME).tex
	pdflatex $(LABNAME).tex


clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

