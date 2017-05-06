MAKEPATH := $(abspath $(firstword $(MAKEFILE_LIST)))
CWD      := $(patsubst %/,%,$(dir $(MAKEPATH)))


HUGO = 0.20.7


.PHONY: build
build: build-hugo
build: build-tools

.PHONY: build-hugo
build-hugo: drop-hugo
build-hugo:
	docker build -t build-hugo-image -f $(CWD)/hugo/build.Dockerfile \
	             --force-rm --no-cache --pull --rm \
	             --build-arg VERSION=$(HUGO) \
	             $(CWD)/hugo
	docker create --name build-hugo-container build-hugo-image
	docker cp build-hugo-container:/tmp/hugo $(CWD)/hugo/artifacts/hugo
	docker rmi -f build-hugo-image
	docker rm -f build-hugo-container
	docker build -t kamilsk/hugo -f $(CWD)/hugo/pack.Dockerfile \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$$(docker images | grep '^alpine\s\+latest' | awk '{print $$3}') \
	             --build-arg VERSION=$(HUGO) \
	             $(CWD)/hugo
	rm $(CWD)/hugo/artifacts/*

.PHONY: build-tools
build-tools: drop-tools clean-invalid-tools
build-tools:
	docker pull golang:latest
	docker build --build-arg BASE=$$(docker images | grep '^golang\s\+latest' | awk '{print $$3}') \
	             -t kamilsk/go-tools:latest \
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



.PHONY: publish
publish: publish-hugo
publish: publish-tools

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
drop-hugo: clean-invalid-hugo
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
