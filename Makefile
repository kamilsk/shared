MAKEPATH := $(abspath $(firstword $(MAKEFILE_LIST)))
CWD      := $(patsubst %/,%,$(dir $(MAKEPATH)))


HUGO     = 0.21
DEPTH    = 1.1.1
GLIDE    = 0.12.3
RELEASER = 0.19.0
REPORTER = 2.1.0

.PHONY: build
build: build-hugo
build: build-tools

.PHONY: build-hugo
build-hugo: drop-hugo
build-hugo: clean-hugo-artifacts
build-hugo:
	mkdir -p $(CWD)/hugo/artifacts
	docker rmi -f build-hugo-image     &>/dev/null || true
	docker rm  -f build-hugo-container &>/dev/null || true
	#
	docker build -f $(CWD)/hugo/build.Dockerfile \
	             -t build-hugo-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$$(docker images | grep '^alpine\s\+latest' | awk '{print $$3}') \
	             --build-arg VERSION=$(HUGO) \
	             $(CWD)/hugo
	docker create --name build-hugo-container build-hugo-image
	docker cp build-hugo-container:/tmp/hugo/hugo $(CWD)/hugo/artifacts/
	docker cp build-hugo-container:/tmp/meta.data $(CWD)/hugo/artifacts/
	#
	docker rmi -f build-hugo-image
	docker rm -f  build-hugo-container
	#
	docker build -f $(CWD)/hugo/pack.Dockerfile \
	             -t kamilsk/hugo \
	             --force-rm --no-cache --pull --rm \
	             $(CWD)/hugo

.PHONY: build-tools
build-tools: drop-tools
build-tools: clean-tools-artifacts
build-tools:
	mkdir -p $(CWD)/tools/artifacts
	docker rmi -f build-go-tools-image     &>/dev/null || true
	docker rm  -f build-go-tools-container &>/dev/null || true
	#
	docker build -f $(CWD)/tools/build.alpine.Dockerfile \
	             -t build-go-tools-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$$(docker images | grep '^golang\s\+alpine' | awk '{print $$3}') \
	             --build-arg DEPTH=$(DEPTH) \
	             --build-arg GLIDE=$(GLIDE) \
	             --build-arg RELEASER=$(RELEASER) \
	             --build-arg REPORTER=$(REPORTER) \
	             $(CWD)/tools
	docker create --name build-go-tools-container build-go-tools-image
	docker cp build-go-tools-container:/tmp/apicompat               $(CWD)/tools/artifacts/
	docker cp build-go-tools-container:/tmp/benchcmp                $(CWD)/tools/artifacts/
	docker cp build-go-tools-container:/tmp/depth                   $(CWD)/tools/artifacts/
	docker cp build-go-tools-container:/tmp/easyjson                $(CWD)/tools/artifacts/
	docker cp build-go-tools-container:/tmp/glide/linux-amd64/glide $(CWD)/tools/artifacts/
	docker cp build-go-tools-container:/tmp/godepq                  $(CWD)/tools/artifacts/
	docker cp build-go-tools-container:/tmp/gometalinter            $(CWD)/tools/artifacts/gometalinter/
	docker cp build-go-tools-container:/tmp/goreleaser/goreleaser   $(CWD)/tools/artifacts/
	docker cp build-go-tools-container:/tmp/goreporter              $(CWD)/tools/artifacts/
	docker cp build-go-tools-container:/tmp/honnef                  $(CWD)/tools/artifacts/honnef/
	docker cp build-go-tools-container:/tmp/zb                      $(CWD)/tools/artifacts/
	docker cp build-go-tools-container:/tmp/meta.data               $(CWD)/tools/artifacts/
	#
	docker rmi -f build-go-tools-image
	docker rm  -f build-go-tools-container
	#
	docker build -f $(CWD)/tools/pack.alpine.Dockerfile \
	             -t kamilsk/go-tools:latest \
	             --force-rm --no-cache --pull --rm \
	             $(CWD)/tools


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

.PHONY: clean-hugo-artifacts
clean-hugo-artifacts:
	rm -rf $(CWD)/hugo/artifacts/* &>/dev/null || true

.PHONY: clean-tools-artifacts
clean-tools-artifacts:
	rm -rf $(CWD)/tools/artifacts/* &>/dev/null || true



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
drop-tools: clean-invalid-tools
drop-tools:
	docker images --all \
	| grep '^kamilsk\/go-tools\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep -v '^<none>\s\+' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true



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
