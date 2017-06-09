MAKEPATH := $(abspath $(firstword $(MAKEFILE_LIST)))
CWD      := $(patsubst %/,%,$(dir $(MAKEPATH)))

include experiments/Makefile
include hugo/Makefile
include protobuf/Makefile
include tools/Makefile

.PHONY: clean
clean: clean-experiments-artifacts clean-invalid-experiments
clean: clean-hugo-artifacts clean-invalid-hugo
clean: clean-invalid-protobuf clean-protobuf-artifacts
clean: clean-invalid-tools clean-tools-artifacts

.PHONY: build
build: build-hugo
build: build-protobuf
build: build-tools

.PHONY: publish
publish: publish-hugo
publish: publish-protobuf
publish: publish-tools

.PHONY: pull
pull: pull-hugo
pull: pull-protobuf
pull: pull-tools
