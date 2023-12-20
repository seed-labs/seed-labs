
LAB    = Buffer_Overflow_Server
LABPDF = $(LAB).pdf $(LAB)_ARM64.pdf
CF     = ../../common-files
DEPEND = $(CF)/header.tex $(CF)/copyright.tex $(CF)/submission.tex \
	 part_nonexecutable_stack.tex 
SHARED = overview.tex labenv.tex task_shellcode.tex \
	 task_level_1.tex task_level_2.tex \
	 task_level_3.tex task_level_4.tex task_countermeasure.tex

all: $(LABPDF)

$(LAB).pdf: $(LAB).tex $(DEPEND) $(SHARED)
	pdflatex $<
	pdflatex $<

$(LAB)_ARM64.pdf: $(LAB)_ARM64.tex $(DEPEND) $(SHARED)
	pdflatex $<
	pdflatex $<

clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

