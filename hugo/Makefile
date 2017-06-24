HUGO          = 0.24.1
ALPINE_LATEST = $(shell docker images | grep '^alpine\s\+latest' | awk '{print $$3}')

.PHONY: build-hugo
build-hugo: build-hugo-image
build-hugo: get-hugo-artifacts
build-hugo: pack-hugo
build-hugo:
	make clean-hugo-artifacts
	make clean-hugo-build-image

.PHONY: build-hugo-image
build-hugo-image: clean-hugo-build-image
build-hugo-image:
	docker build -f $(CWD)/hugo/build.Dockerfile \
	             -t hugo_build-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$(ALPINE_LATEST) \
	             --build-arg VERSION=$(HUGO) \
	             $(CWD)/hugo

.PHONY: clean-hugo-artifacts
clean-hugo-artifacts:
	rm -rf $(CWD)/hugo/artifacts &>/dev/null || true

.PHONY: clean-hugo-build-image
clean-hugo-build-image:
	docker rmi -f hugo_build-image &>/dev/null || true

.PHONY: clean-invalid-hugo
clean-invalid-hugo:
	docker images --all \
	| grep '^kamilsk\/hugo\s\+' \
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

.PHONY: get-hugo-artifacts
get-hugo-artifacts: clean-hugo-artifacts
get-hugo-artifacts:
	docker rm -f hugo_build-container &>/dev/null || true
	mkdir -p $(CWD)/hugo/artifacts
	docker create --name hugo_build-container hugo_build-image
	docker cp hugo_build-container:/tmp/hugo      $(CWD)/hugo/artifacts/
	docker cp hugo_build-container:/tmp/meta.data $(CWD)/hugo/artifacts/
	cat $(CWD)/hugo/artifacts/meta.data \
	  | sed '/START METADATA/d' \
	  | sed '/END METADATA/d' \
	  | sed 's/[ ]*$$//' \
	  > $(CWD)/hugo/latest.log
	docker rm -f hugo_build-container

.PHONY: in-hugo
in-hugo:
	docker run --rm -it kamilsk/hugo /bin/sh

.PHONY: in-hugo-build-image
in-hugo-build-image:
	if docker images --all | grep hugo_build-image; then \
		docker run --rm -it hugo_build-image; \
	else \
		echo Build image not found; \
	fi

.PHONY: pack-hugo
pack-hugo: drop-hugo
pack-hugo:
	docker build -f $(CWD)/hugo/pack.Dockerfile \
	             -t kamilsk/hugo \
	             --force-rm --no-cache --pull --rm \
	             $(CWD)/hugo

.PHONY: process-hugo
process-hugo: drop-hugo build-hugo publish-hugo

.PHONY: publish-hugo
publish-hugo:
	docker push kamilsk/hugo

.PHONY: pull-hugo
pull-hugo:
	docker pull kamilsk/hugo
