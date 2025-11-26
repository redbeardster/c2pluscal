.PHONY: all build install test test-verbose clean

all: build

build:
	cd src && dune build

install: build
	cd src && dune install

test:
	@echo "Running C2PlusCal test suite..."
	@cd tests && bash run_tests.sh

test-verbose:
	@echo "Running C2PlusCal test suite (verbose)..."
	@cd tests && bash run_tests.sh --verbose

clean:
	cd src && dune clean
	rm -f tests/*.tla tests/*.cfg tests/*.dump
	rm -f *.tla *.cfg *.dump

.DEFAULT_GOAL := build
