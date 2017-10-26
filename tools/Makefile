GLIDE         = 0.13.0
PROTOC        = 3.4.1
RELEASER      = 0.35.5
RETRY         = 2.1.2
SEMAPHORE     = 4.2.0
GOLANG_ALPINE = $(shell docker images | grep '^golang\s\+alpine' | awk '{print $$3}')

include $(CWD)/tools/make/easyjson.mk
include $(CWD)/tools/make/glide.mk
include $(CWD)/tools/make/gometalinter.mk
include $(CWD)/tools/make/goreleaser.mk
include $(CWD)/tools/make/protobuf.mk
include $(CWD)/tools/make/retry.mk
include $(CWD)/tools/make/semaphore.mk

.PHONY: build-tools
build-tools: build-easyjson
build-tools: build-glide
build-tools: build-gometalinter
build-tools: build-goreleaser
build-tools: build-protobuf
build-tools: build-retry
build-tools: build-semaphore
build-tools: pack-tools
build-tools: clean-tools-artifacts
build-tools:
	make clean-tools-build-image

.PHONY: clean-invalid-tools
clean-invalid-tools:
	docker images --all \
	| grep '^kamilsk\/go-tools\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep '^<none>\s\+' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: clean-tools-artifacts
clean-tools-artifacts:
	rm -rf $(CWD)/tools/artifacts &>/dev/null || true

.PHONY: clean-tools-build-image
clean-tools-build-image: clean-easyjson-build-image
clean-tools-build-image: clean-glide-build-image
clean-tools-build-image: clean-gometalinter-build-image
clean-tools-build-image: clean-goreleaser-build-image
clean-tools-build-image: clean-protobuf-build-image
clean-tools-build-image: clean-retry-build-image
clean-tools-build-image: clean-semaphore-build-image

.PHONY: drop-tools
drop-tools: clean-invalid-tools
drop-tools:
	docker images --all \
	| grep '^kamilsk\/go-tools\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep 'latest' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: in-tools
in-tools:
	docker run --rm -it kamilsk/go-tools

.PHONY: pack-tools
pack-tools: drop-tools
pack-tools:
	docker build -f $(CWD)/tools/docker/pack.Dockerfile \
	             -t kamilsk/go-tools \
	             --force-rm --no-cache --pull --rm \
	             $(CWD)/tools
	echo '' >  $(CWD)/tools/latest.log
	echo '' >> $(CWD)/tools/latest.log
	echo 'METADATA:short' \
	  >> $(CWD)/tools/latest.log
	echo 'Alpine Linux with Go and most useful Go tools' \
	  >> $(CWD)/tools/latest.log
	echo '' >> $(CWD)/tools/latest.log
	echo 'METADATA:full' \
	  >> $(CWD)/tools/latest.log
	echo 'Alpine Linux with Go ([golang](https://hub.docker.com/_/golang/):alpine.$(GOLANG_ALPINE)), g++, gcc, git, libc-dev, mercurial and' \
	  >> $(CWD)/tools/latest.log
	for metadata in $(shell ls $(CWD)/tools/artifacts/*.metadata); do \
		cat $$metadata >> $(CWD)/tools/latest.log; \
	done
	echo '' >> $(CWD)/tools/latest.log
	echo '[Dockerfile](https://github.com/kamilsk/shared/blob/docker-go-v1/tools)' \
	  >> $(CWD)/tools/latest.log
	echo '[Useful Makefile](https://github.com/kamilsk/shared/blob/makefile-go-v1/docker/tools.mk)' \
	  >> $(CWD)/tools/latest.log
	echo '' >> $(CWD)/tools/latest.log

.PHONY: process-tools
process-tools: drop-tools build-tools publish-tools

.PHONY: publish-tools
publish-tools:
	docker push kamilsk/go-tools

.PHONY: pull-tools
pull-tools:
	docker pull kamilsk/go-tools
