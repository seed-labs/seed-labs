
LAB    = Mitnick_Attack
LABPDF = $(LAB).pdf

CF      = ../../common-files
DEPEND  = $(CF)/header.tex $(CF)/copyright.tex $(CF)/submission.tex
DEPEND2 = $(CF)/container/setup.tex $(CF)/container/volumes.tex 
DEPEND3 = $(CF)/container/privileged_mode.tex $(CF)/container/host_mode.tex

all: $(LABPDF)

%.pdf: %.tex $(DEPEND) $(DEPEND2) $(DEPEND3)
	pdflatex $<
	pdflatex $<

cp:
	cp $(LABPDF) $(WEB)

clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~

