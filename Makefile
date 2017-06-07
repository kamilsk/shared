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
build: build-experimental-tools

.PHONY: publish
publish: publish-hugo
publish: publish-protobuf
publish: publish-tools
publish: publish-experimental-tools


.PHONY: clean-invalid
clean-invalid:
	docker images --all \
	| grep '^<none>\s\+' \
	| awk '{print $$3}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: clean-invalid-golang
clean-invalid-golang:
	docker images --all \
	| grep '^golang\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep '^<none>\s\+' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true
