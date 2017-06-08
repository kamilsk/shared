MAKEPATH := $(abspath $(firstword $(MAKEFILE_LIST)))
CWD      := $(patsubst %/,%,$(dir $(MAKEPATH)))

include experiments/Makefile
include hugo/Makefile
include protobuf/Makefile
include tools/Makefile

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
