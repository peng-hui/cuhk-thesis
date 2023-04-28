MAIN ?= p
DIFF ?= HEAD^
CODE := $(addsuffix .tex,$(filter-out %.tex,$(wildcard code/*)))
FIGS := $(patsubst %.svg,%.pdf,$(wildcard fig/*.svg))
ODGS := $(patsubst %.odg,%.pdf,$(wildcard fig/*.odg))
PLOT := $(patsubst %.gp,%.tex,$(wildcard data/*.gp))
DEPS := rev.tex abstract.txt $(CODE) $(FIGS) $(ODGS) $(PLOT)
LTEX := --latex-args="-synctex=1 -shell-escape" --latex-cmd="xelatex"
BTEX := --bibtex-args="-min-crossrefs=99"
SHELL:= $(shell echo $$SHELL)

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
  INKSCAPE=/Applications/Inkscape.app/Contents/Resources/bin/inkscape
  SOFFICE=/Applications/LibreOffice.app/Contents/MacOS/soffice
  SED=sed -i ""
else
  INKSCAPE=inkscape
  SOFFICE=soffice
  SED=sed -i
endif

all: $(DEPS) ## generate a pdf
	chmod a+x bin/*
	@$(SED) 's/\\usepackage\[\]{minted}/\\usepackage\[outputdir=latex.out\]{minted}/g' pkgs.tex
	@TEXINPUTS= bin/latexrun $(LTEX) $(BTEX) $(MAIN)
	cp latex.out/$(MAIN).synctex.gz .
	@$(SED) 's/\\usepackage\[outputdir=latex.out\]{minted}/\\usepackage\[\]{minted}/g' pkgs.tex

submit: $(DEPS) ## proposal function
	@for f in $(wildcard submit-*.tex); do \
		TEXINPUTS= bin/latexrun $$f; \
	done

diff: $(DEPS) ## generate diff-highlighed pdf
	@bin/diff.sh $(DIFF)

help: ## print help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	  | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

rev.tex: FORCE
	@printf '\\gdef\\therev{%s}\n\\gdef\\thedate{%s}\n' \
	   "$(shell git rev-parse --short HEAD)"            \
	   "$(shell git log -1 --format='%ci' HEAD)" > $@

code/%.tex: code/% ## build highlighted tex code from source code
	pygmentize -P tabsize=4 -P mathescape -f latex $^ | bin/mark.py > $@

fig/%.pdf: fig/%.svg ## generate pdf from svg
	$(INKSCAPE) --without-gui -f ${CURDIR}/$^ -D -A ${CURDIR}/$@

fig/%.pdf: fig/%.odg ## generate pdf from LibreOffice Draw
	$(SOFFICE) --convert-to pdf $< --outdir $(@D)
	pdfcrop $@ $@

data/%.tex: data/%.gp ## generate plot
	gnuplot $^

draft: $(DEPS) ## generate pdf with a draft info
	echo -e '\\newcommand*{\\DRAFT}{}' >> rev.tex
	@TEXINPUTS= bin/latexrun $(LTEX) $(BTEX) $(MAIN)

watermark: $(DEPS) ## generate pdf with a watermark
	echo -e '\\usepackage[firstpage]{draftwatermark}' >> rev.tex
	@TEXINPUTS= bin/latexrun $(LTEX) $(BTEX) $(MAIN)

spell: ## run a spell check
	@for i in *.tex; do bin/aspell.sh tex $$i; done
	@for i in *.tex; do bin/double.pl $$i; done
	@for i in *.tex; do bin/abbrv.pl  $$i; done
	@bin/hyphens.sh *.tex
	@bin/shortmonth.sh *.tex
	@pdftotext $(MAIN).pdf /dev/stdout | grep '??' | cat
	@for i in fig/*.svg; do bin/aspell.sh svg $$i; done
	@for i in code/*.c; do bin/aspell.sh code $$i; done

bib: all ## print bib used in the paper
	bibexport -n latex.out/$(MAIN).aux

cleancomments: ## clean up comments for submitting tex files
	@for i in *.tex; do bin/cleancomments $$i; done

clean: ## clean up
	@bin/latexrun --clean
	rm -f abstract.txt
	rm -f $(MAIN).synctex.gz

distclean: clean ## clean up completely
	rm -f code/*.tex
	git checkout code/fmt.tex
	rm -rf _minted-p
	rm -rf latex.out

abstract.txt: abstract.tex $(MAIN).tex ## generate abstract.txt
	@bin/mkabstract $(MAIN).tex $< | fmt -w2000 | sed 's/\.  /. /g' > $@

.PHONY: all help FORCE draft clean spell distclean init bib
