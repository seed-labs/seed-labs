
LAB    = Web_XSS_Elgg
LABPDF = $(LAB).pdf


all: $(LABPDF)


%.pdf: %.tex
	pdflatex $<
	pdflatex $<


clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

source:
	mkdir $(TARGET)
	cp header.tex $(TARGET)
	cp copyright.tex $(TARGET)
	cp Makefile $(TARGET)
	cp $(LAB).tex $(TARGET) 
	mkdir $(TARGET)/Figs_Web_Common
	cp ./Figs_Web_Common/HTTPHeaderLive.pdf $(TARGET)/Figs_Web_Common
	cp ./Figs_Web_Common/webdevtools_01_request.png $(TARGET)/Figs_Web_Common
	cp ./Figs_Web_Common/webdevtools_02_two_panes.png $(TARGET)/Figs_Web_Common
	cp ./Figs_Web_Common/webdevtools_02_two_panes.png $(TARGET)/Figs_Web_Common
	cp ./Figs_Web_Common/webdevtools_03-1.png $(TARGET)/Figs_Web_Common
	cp ./Figs_Web_Common/webdevtools_03-2.png $(TARGET)/Figs_Web_Common
	cp ./Figs_Web_Common/errorCheckMark.png $(TARGET)/Figs_Web_Common
	cp ./Figs_Web_Common/consoleError2.png $(TARGET)/Figs_Web_Common

