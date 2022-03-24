#
# Makefile for I-D update presentations
#
THEME=Nord
SHELL=/bin/bash -O globstar

SRC:=$(wildcard bm-*.md)
USER:=$(shell id -u)
GROUP:=$(shell id -g)
MARP:= docker run --rm --init \
			-v $(CURDIR):/home/marp/app/ \
			-e LANG=$(LANG) \
			-e MARP_USER="$(USER):$(GROUP)" \
			-p 37717:37717 \
			-p 8080:8080 \
			marpteam/marp-cli

.PHONY: all
all: pdf

.PHONY: pdf
PDF:=$(patsubst %.md,%.pdf,$(SRC))
pdf: $(PDF)

%.pdf: %.md
	@echo "*** Generating PDF Slide Deck $* ***"
	$(MARP) --pdf $<

.PHONY: watch
watch:
	$(MARP) --server .

.PHONY: clean
clean:
	@echo "*** Cleaning up ***"
	rm -rf $(PDF)
