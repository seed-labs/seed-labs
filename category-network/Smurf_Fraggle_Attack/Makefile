
LAB    = Smurf_Fraggle_Attack
LABPDF = $(LAB).pdf
CNLAB  = Smurf_Fraggle_Attack_cn
CNPDF  = $(CNLAB).pdf

CF      = ../../common-files
DEPEND  = $(CF)/header.tex $(CF)/copyright.tex $(CF)/emulator/setup.tex
CNDEPEND = $(CF)/header_cn.tex $(CF)/copyright_cn.tex $(CF)/emulator/setup_cn.tex

all: $(LABPDF)

cn: $(CNPDF)

%.pdf: %.tex $(DEPEND)
	pdflatex $<
	pdflatex $<

$(CNPDF): $(CNLAB).tex $(DEPEND) $(CNDEPEND)
	xelatex $(CNLAB).tex
	xelatex $(CNLAB).tex

clean:
	rm -f *.log *.dvi *.xdv *.aux *.bbl *.blg *~ *.out *.det
	@@rm -f *~

