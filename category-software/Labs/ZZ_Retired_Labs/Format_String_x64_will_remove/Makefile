
LAB    = Format_String_x64
LABPDF = $(LAB).pdf
CF     = ../../common-files
DEPEND  = $(CF)/header.tex $(CF)/copyright.tex $(CF)/submission.tex 
DEPEND2 = $(CF)/guidelines/reverse_shell.tex $(CF)/guidelines/reverse_shellcode_x64.tex


all: $(LABPDF)

%.pdf: %.tex $(DEPEND) $(DEPEND2)
	pdflatex $<
	pdflatex $<

clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~


