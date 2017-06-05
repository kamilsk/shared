HUGO = 0.21

.PHONY: build-hugo
build-hugo: build-hugo-image
build-hugo: get-hugo-artifacts
build-hugo: pack-hugo
build-hugo:
	make clean-hugo-artifacts
	make clean-hugo-image

.PHONY: build-hugo-image
build-hugo-image: clean-hugo-image
build-hugo-image:
	docker build -f $(CWD)/hugo/build.Dockerfile \
	             -t build-hugo-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$$(docker images | grep '^alpine\s\+latest' | awk '{print $$3}') \
	             --build-arg VERSION=$(HUGO) \
	             $(CWD)/hugo

.PHONY: clean-invalid-hugo
clean-invalid-hugo:
	docker images --all \
	| grep '^kamilsk\/hugo\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep '^<none>\s\+' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: clean-hugo-artifacts
clean-hugo-artifacts:
	rm -rf $(CWD)/hugo/artifacts &>/dev/null || true

.PHONY: clean-hugo-image
clean-hugo-image:
	docker rmi -f build-hugo-image &>/dev/null || true

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
	docker rm -f build-hugo-container &>/dev/null || true
	mkdir -p $(CWD)/hugo/artifacts
	docker create --name build-hugo-container build-hugo-image
	docker cp build-hugo-container:/tmp/hugo      $(CWD)/hugo/artifacts/
	docker cp build-hugo-container:/tmp/meta.data $(CWD)/hugo/artifacts/
	cat $(CWD)/hugo/artifacts/meta.data | sed '/START METADATA/d' | sed '/END METADATA/d' | sed 's/[ ]*$$//' \
	  > $(CWD)/hugo/latest.log
	docker rm -f build-hugo-container

.PHONY: in-hugo
in-hugo:
	docker run --rm -it kamilsk/hugo:latest /bin/sh

.PHONY: in-hugo-image
in-hugo-image:
	docker run --rm -it build-hugo-image

.PHONY: pack-hugo
pack-hugo: drop-hugo
pack-hugo:
	docker build -f $(CWD)/hugo/pack.Dockerfile \
	             -t kamilsk/hugo:latest \
	             --force-rm --no-cache --pull --rm \
	             $(CWD)/hugo

.PHONY: publish-hugo
publish-hugo:
	docker push kamilsk/hugo:latest
