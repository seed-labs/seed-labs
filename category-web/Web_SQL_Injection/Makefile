
LAB    = Web_SQL_Injection
LABPDF = $(LAB).pdf

CF     = ../../common-files
CFW    = ../Web_Common
DEPEND  = $(CF)/header.tex $(CF)/copyright.tex $(CF)/submission.tex
DEPEND2 = $(CF)/container/setup.tex
DEPEND3 = $(CFW)/mysql.tex 


all: $(LABPDF)

%.pdf: %.tex $(DEPEND) $(DEPEND2) $(DEPEND3)
	pdflatex $<
	pdflatex $<

clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

