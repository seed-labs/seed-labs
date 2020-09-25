
LAB    = Buffer_Overflow
LABPDF = $(LAB).pdf
TARGET = /home/wedu/works/source/$(LAB)
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

source:
	mkdir $(TARGET)
	mkdir $(TARGET)/Figs
	cp header.tex $(TARGET)
	cp copyright.tex $(TARGET)
	cp Makefile $(TARGET)
	cp $(LAB).tex $(TARGET) 
	cp ./Figs/bof_jump_to_malicious_code.pdf $(TARGET)/Figs
	cp ./Figs/bof_stack_example.pdf $(TARGET)/Figs
