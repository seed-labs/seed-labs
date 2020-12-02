
LAB    = Web_CSRF_Elgg
LABPDF = $(LAB).pdf

CF     = ../../common-files
CFW    = ../Web_Common
DEPEND  = $(CF)/header.tex $(CF)/copyright.tex $(CF)/submission.tex
DEPEND2 = $(CF)/container/setup.tex 
DEPEND3 = $(CFW)/mysql.tex $(CFW)/elgg_accounts.tex $(CFW)/Web_Dev_Tools.tex


all: $(LABPDF)

%.pdf: %.tex $(DEPEND) $(DEPEND2) $(DEPEND3)
	pdflatex $<
	pdflatex $<

clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

