MAKEPATH := $(abspath $(firstword $(MAKEFILE_LIST)))
CWD      := $(patsubst %/,%,$(dir $(MAKEPATH)))

include experiments/Makefile
include hugo/Makefile
include tools/Makefile

.PHONY: clean
clean: clean-experiments-artifacts clean-invalid-experiments
clean: clean-hugo-artifacts clean-invalid-hugo
clean: clean-invalid-tools clean-tools-artifacts

.PHONY: build
build: build-hugo
build: build-tools

.PHONY: publish
publish: publish-hugo
publish: publish-tools

.PHONY: pull
pull: pull-hugo
pull: pull-tools
