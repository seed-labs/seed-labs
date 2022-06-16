
LAB    = Buffer_Overflow_Setuid
LABPDF = $(LAB).pdf
CF     = ../../common-files
DEPEND = $(CF)/header.tex $(CF)/copyright.tex $(CF)/submission.tex 

all: $(LABPDF)

%.pdf: %.tex $(DEPEND) part_nonexecutable_stack.tex
	pdflatex $<
	pdflatex $<

clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

