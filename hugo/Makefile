HUGO = 0.21

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

.PHONY: clean-hugo-artifacts
clean-hugo-artifacts:
	rm -rf $(CWD)/hugo/artifacts &>/dev/null || true

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

.PHONY: in-hugo
in-hugo:
	docker run --rm -it kamilsk/hugo:latest /bin/sh

.PHONY: publish-hugo
publish-hugo:
	docker push kamilsk/hugo:latest
