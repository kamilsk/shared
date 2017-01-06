MAKEPATH := $(abspath $(firstword $(MAKEFILE_LIST)))
PWD      := $(patsubst %/,%,$(dir $(MAKEPATH)))

.PHONY: build-alpine-gcc
build-alpine-gcc: pull-alpine
build-alpine-gcc: drop-alpine-gcc clean-alpine-gcc
build-alpine-gcc:
	docker build -t kamilsk/golang:1.5-alpine \
	             -f $(PWD)/alpine-gcc/1.5-alpine.Dockerfile \
	             $(PWD)/alpine-gcc
	docker build -t kamilsk/golang:1.6-alpine \
	             -f $(PWD)/alpine-gcc/1.6-alpine.Dockerfile \
	             $(PWD)/alpine-gcc
	docker build -t kamilsk/golang:1.7-alpine \
	             -t kamilsk/golang:alpine \
	             -f $(PWD)/alpine-gcc/1.7-alpine.Dockerfile \
	             $(PWD)/alpine-gcc

.PHONY: build-tools
build-tools: pull-latest
build-tools:
	docker build -t kamilsk/go-tools:latest \
	             -f $(PWD)/tools/Dockerfile \
	             $(PWD)/tools



.PHONY: clean-invalid
clean-invalid:
	docker images --all \
	| grep '^<none>\s\+' \
	| awk '{print $$3}' \
	| xargs docker rmi -f "$$1"

.PHONY: clean-alpine-gcc
clean-invalid-alpine-gcc:
	docker images --all \
	| grep '^kamilsk\/golang\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep '^<none>\s\+' \
	| awk '{print $$2}' \
	| xargs docker rmi -f "$$1"

.PHONY: clean-invalid-golang
clean-invalid-golang:
	docker images --all \
	| grep '^golang\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep '^<none>\s\+' \
	| awk '{print $$2}' \
	| xargs docker rmi -f "$$1"



.PHONY: drop-alpine
drop-alpine:
	docker images --all \
	| grep '^golang\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep 'alpine\s\+' \
	| awk '{print $$2}' \
	| xargs docker rmi -f "$$1"

.PHONY: drop-alpine-gcc
drop-alpine-gcc:
	docker images --all \
	| grep '^kamilsk\/golang\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep -v '^<none>\s\+' \
	| awk '{print $$2}' \
	| xargs docker rmi -f "$$1"



.PHONY: pull-alpine
pull-alpine:
	docker pull golang:1.5-alpine
	docker pull golang:1.6-alpine
	docker pull golang:1.7-alpine
	docker pull golang:alpine

.PHONY: pull-latest
pull-latest:
	docker pull golang:latest



.PHONY: publish-alpine-gcc
publish-alpine-gcc:
	docker push kamilsk/golang:1.5-alpine
	docker push kamilsk/golang:1.6-alpine
	docker push kamilsk/golang:1.7-alpine
	docker push kamilsk/golang:alpine

.PHONY: publish-tools
publish-tools:
	docker push kamilsk/go-tools:latest
