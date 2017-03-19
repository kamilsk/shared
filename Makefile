MAKEPATH := $(abspath $(firstword $(MAKEFILE_LIST)))
CWD      := $(patsubst %/,%,$(dir $(MAKEPATH)))



.PHONY: build
build: build-hugo build-tools

.PHONY: build-hugo
build-hugo: drop-hugo clean-invalid-hugo
build-hugo:
	docker pull alpine:latest
	docker build -t kamilsk/hugo:latest \
	             -f $(CWD)/hugo/Dockerfile \
	             $(CWD)/hugo

.PHONY: build-tools
build-tools: drop-tools clean-invalid-tools
build-tools:
	docker pull golang:latest
	docker build -t kamilsk/go-tools:latest \
	             -f $(CWD)/tools/Dockerfile \
	             $(CWD)/tools



.PHONY: in-hugo
in-hugo:
	docker run --rm -it \
	           kamilsk/hugo:latest \
	           /bin/sh

.PHONY: in-tools
in-tools:
	docker run --rm -it \
	           kamilsk/go-tools:latest \
	           /bin/sh



.PHONY: publish-hugo
publish-hugo:
	docker push kamilsk/hugo:latest

.PHONY: publish-tools
publish-tools:
	docker push kamilsk/go-tools:latest



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

.PHONY: clean-invalid-hugo
clean-invalid-hugo:
	docker images --all \
	| grep '^kamilsk\/hugo\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep '^<none>\s\+' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: clean-invalid-tools
clean-invalid-tools:
	docker images --all \
	| grep '^kamilsk\/go-tools\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep '^<none>\s\+' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true



.PHONY: drop-hugo
drop-hugo:
	docker images --all \
	| grep '^kamilsk\/hugo\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep -v '^<none>\s\+' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: drop-tools
drop-tools:
	docker images --all \
	| grep '^kamilsk\/go-tools\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep -v '^<none>\s\+' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true
