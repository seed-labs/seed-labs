
LAB    = Mitnick_Attack
LABPDF = $(LAB).pdf
WEB    = ../../seedwebsite/Labs_16.04/PDF


all: $(LABPDF) 


%.pdf: %.tex
	pdflatex $<
	pdflatex $<

git:
	git add .
	git commit -m"..."
	git push

cp:
	cp $(LABPDF) $(WEB)

clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

