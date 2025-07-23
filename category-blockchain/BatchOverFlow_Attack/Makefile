
LAB    = BatchOverFlow_Attack
LABPDF = $(LAB).pdf

CF      = ../../common-files
DEPEND  = $(CF)/header.tex $(CF)/copyright.tex $(CF)/submission.tex \
	  $(CF)/emulator/setup.tex $(CF)/emulator/map.tex \
	  $(CF)/emulator/filter_and_replay.tex

all: $(LABPDF)

%.pdf: %.tex 
	pdflatex $<
	pdflatex $<

clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

