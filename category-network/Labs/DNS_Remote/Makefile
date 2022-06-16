
LAB    = DNS_Remote
LABPDF = $(LAB).pdf

CF      = ../../common-files
DEPEND  = $(CF)/header.tex $(CF)/copyright.tex $(CF)/submission.tex
DEPEND2 = $(CF)/container/setup.tex $(CF)/container/volumes.tex $(CF)/container/host_mode.tex
DEPEND3 = $(CF)/DNS/summary_of_config.tex $(CF)/DNS/setup_testing.tex

all: $(LABPDF)

%.pdf: %.tex $(DEPEND) $(DEPEND2) $(DEPEND3)
	pdflatex $<
	pdflatex $<


bib: $(LAB)

$(LAB):
	pdflatex $@.tex
	bibtex $@
	pdflatex $@.tex
	pdflatex $@.tex


clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

