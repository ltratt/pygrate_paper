.SUFFIXES: .ltx .pdf .svg

.svg.pdf:
	inkscape --export-filename=$@ $<

DIAGRAMS =

all: pygrate_paper.pdf

clean:
	rm -rf ${DIAGRAMS} ${DIAGRAMS:S/.pdf/.eps/}
	rm -rf pygrate_paper.aux pygrate_paper.bbl pygrate_paper.blg pygrate_paper.dvi pygrate_paper.log pygrate_paper.ps pygrate_paper.pdf pygrate_paper.toc pygrate_paper.out pygrate_paper.snm pygrate_paper.nav pygrate_paper.vrb texput.log

pygrate_paper.pdf: bib.bib pygrate_paper.ltx pygrate_paper_preamble.fmt softdev.sty ${DIAGRAMS}
	pdflatex pygrate_paper.ltx
	bibtex pygrate_paper
	pdflatex pygrate_paper.ltx
	pdflatex pygrate_paper.ltx

pygrate_paper_preamble.fmt: pygrate_paper_preamble.ltx softdev.sty
	set -e; \
	  tmpltx=`mktemp`; \
	  cat ${@:fmt=ltx} > $${tmpltx}; \
	  grep -v "%&${@:_preamble.fmt=}" ${@:_preamble.fmt=.ltx} >> $${tmpltx}; \
	  pdftex -ini -jobname="${@:.fmt=}" "&pdflatex" mylatexformat.ltx $${tmpltx}; \
	  rm $${tmpltx}

bib.bib: softdevbib/softdev.bib local.bib
	softdevbib/bin/prebib -x month softdevbib/softdev.bib > bib.bib
	softdevbib/bin/prebib -x month local.bib >> bib.bib

softdevbib/softdev.bib:
	git submodule init
	git submodule update
