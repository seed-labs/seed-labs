
LAB    = Buffer_Overflow_Server
LABPDF = $(LAB).pdf
CF     = ../../common-files
DEPEND = $(CF)/header.tex $(CF)/copyright.tex $(CF)/submission.tex $(CF)/guidelines/shellcode.tex \
	 part_nonexecutable_stack.tex 

all: $(LABPDF)

%.pdf: %.tex $(DEPEND)
	pdflatex $<
	pdflatex $<

clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

