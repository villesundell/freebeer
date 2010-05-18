# Change this to sane values for you
DOC_PREFIX=$(HOME)/build/
PDF_COMMAND=rubber
PDF_FLAGS=-p -d -f
PDF_VIEWER=evince
# Stop changing here

MAIN_DOCUMENT=book

INTERMEDIATE_FILES=*.pdf *.ps *.aux *.bbl *.blg *.idx *.log *.out *.toc *.lof *.lot *.nlo *.dvi

all: book view


book: $(PDF_COMMAND) $(DOC_PREFIX)
	mv $(MAIN_DOCUMENT).pdf $(DOC_PREFIX)
	$(MAKE) clean

rubber: $(DOC_PREFIX) 
	$(PDF_COMMAND) $(PDF_FLAGS) $(MAIN_DOCUMENT).tex
	$(PDF_COMMAND) $(PDF_FLAGS) $(MAIN_DOCUMENT).tex

pdflatex: $(DOC_PREFIX)
	$(PDF_COMMAND) $(PDF_FLAGS) $(MAIN_DOCUMENT).tex
	bibtex $(MAIN_DOCUMENT)
	$(PDF_COMMAND) $(PDF_FLAGS) $(MAIN_DOCUMENT).tex
	$(PDF_COMMAND) $(PDF_FLAGS) $(MAIN_DOCUMENT).tex

clean:
	rm -f $(INTERMEDIATE_FILES)

mrproper: clean
	rm -f $(DOC_PREFIX)$(MAIN_DOCUMENT).pdf

view:
	@if [ ! -z "$(PDF_VIEWER)" ]; then \
		if [ ! -f /tmp/$(MAIN_DOCUMENT).pid ] || \
		! ps x | grep -q "^[ ]*$$(cat /tmp/$(MAIN_DOCUMENT).pid)\>"; then \
			$(PDF_VIEWER) $(DOC_PREFIX)$(MAIN_DOCUMENT).pdf & \
			echo -n $$! > /tmp/$(MAIN_DOCUMENT).pid ; \
		fi ; \
	fi

$(DOC_PREFIX):
	mkdir -p $(DOC_PREFIX)

.PHONY: book clean mrproper view 
