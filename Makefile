MAKEPATH := $(abspath $(firstword $(MAKEFILE_LIST)))
CWD      := $(patsubst %/,%,$(dir $(MAKEPATH)))



.PHONY: pull-alpine
pull-alpine:
	docker pull golang:1.5-alpine
	docker pull golang:1.6-alpine
	docker pull golang:1.7-alpine
	docker pull golang:1.8-alpine
	docker pull golang:alpine

.PHONY: pull-latest
pull-latest:
	docker pull golang:latest



.PHONY: build
build: build-alpine-gcc build-hugo build-tools

.PHONY: build-alpine-gcc
build-alpine-gcc: pull-alpine
build-alpine-gcc: drop-alpine-gcc clean-invalid-alpine-gcc
build-alpine-gcc:
	docker build -t kamilsk/golang:1.5-alpine \
	             -f $(CWD)/alpine-gcc/1.5-alpine.Dockerfile \
	             $(CWD)/alpine-gcc
	docker build -t kamilsk/golang:1.6-alpine \
	             -f $(CWD)/alpine-gcc/1.6-alpine.Dockerfile \
	             $(CWD)/alpine-gcc
	docker build -t kamilsk/golang:1.7-alpine \
	             -f $(CWD)/alpine-gcc/1.7-alpine.Dockerfile \
	             $(CWD)/alpine-gcc
	docker build -t kamilsk/golang:1.8-alpine \
	             -t kamilsk/golang:alpine \
	             -f $(CWD)/alpine-gcc/1.8-alpine.Dockerfile \
	             $(CWD)/alpine-gcc

.PHONY: build-hugo
build-hugo: drop-hugo clean-invalid-hugo
build-hugo:
	docker pull alpine:latest
	docker build -t kamilsk/hugo:latest \
	             -f $(CWD)/hugo/Dockerfile \
	             $(CWD)/hugo

.PHONY: build-tools
build-tools: pull-latest
build-tools: drop-tools clean-invalid-tools
build-tools:
	docker build -t kamilsk/go-tools:latest \
	             -f $(CWD)/tools/Dockerfile \
	             $(CWD)/tools



.PHONY: in-alpine-gcc-1.5
in-alpine-gcc-1.5:
	docker run --rm -it \
	           kamilsk/golang:1.5-alpine \
	           /bin/sh

.PHONY: in-alpine-gcc-1.6
in-alpine-gcc-1.6:
	docker run --rm -it \
	           kamilsk/golang:1.6-alpine \
	           /bin/sh

.PHONY: in-alpine-gcc-1.7
in-alpine-gcc-1.7:
	docker run --rm -it \
	           kamilsk/golang:1.7-alpine \
	           /bin/sh

.PHONY: in-alpine-gcc-1.8
in-alpine-gcc-1.8:
	docker run --rm -it \
	           kamilsk/golang:1.8-alpine \
	           /bin/sh

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



.PHONY: publish-alpine-gcc
publish-alpine-gcc:
	docker push kamilsk/golang:1.5-alpine
	docker push kamilsk/golang:1.6-alpine
	docker push kamilsk/golang:1.7-alpine
	docker push kamilsk/golang:1.8-alpine
	docker push kamilsk/golang:alpine

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

.PHONY: clean-invalid-alpine-gcc
clean-invalid-alpine-gcc:
	docker images --all \
	| grep '^kamilsk\/golang\s\+' \
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



.PHONY: drop-alpine-gcc
drop-alpine-gcc:
	docker images --all \
	| grep '^kamilsk\/golang\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep -v '^<none>\s\+' \
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
