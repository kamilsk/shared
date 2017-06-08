GLIDE    = 0.12.3
RELEASER = 0.20.2
RETRY    = 2.1.2

.PHONY: build-tools
build-tools: build-tools-image
build-tools: get-tools-artifacts
build-tools: pack-tools
build-tools:
	make clean-tools-artifacts
	make clean-tools-build-image

.PHONY: build-tools-image
build-tools-image: clean-tools-build-image
build-tools-image:
	docker build -f $(CWD)/tools/build.Dockerfile \
	             -t go-tools-build-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$$(docker images | grep '^golang\s\+alpine' | awk '{print $$3}') \
	             --build-arg GLIDE=$(GLIDE) \
	             --build-arg RELEASER=$(RELEASER) \
	             --build-arg RETRY=$(RETRY) \
	             $(CWD)/tools

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
clean-tools-build-image:
	docker rmi -f go-tools-build-image &>/dev/null || true

.PHONY: drop-tools
drop-tools: clean-invalid-tools
drop-tools:
	docker images --all \
	| grep '^kamilsk\/go-tools\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep 'latest' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: get-tools-artifacts
get-tools-artifacts: clean-tools-artifacts
get-tools-artifacts:
	docker rm -f go-tools-container &>/dev/null || true
	mkdir -p $(CWD)/tools/artifacts
	docker create --name go-tools-container go-tools-build-image
	docker cp go-tools-container:/tmp/easyjson     $(CWD)/tools/artifacts/
	docker cp go-tools-container:/tmp/glide        $(CWD)/tools/artifacts/
	docker cp go-tools-container:/tmp/gometalinter $(CWD)/tools/artifacts/
	docker cp go-tools-container:/tmp/goreleaser   $(CWD)/tools/artifacts/
	docker cp go-tools-container:/tmp/retry        $(CWD)/tools/artifacts/
	docker cp go-tools-container:/tmp/meta.data    $(CWD)/tools/artifacts/
	cat $(CWD)/tools/artifacts/meta.data | sed '/START METADATA/d' | sed '/END METADATA/d' | sed 's/[ ]*$$//' \
	  > $(CWD)/tools/latest.log
	docker rm -f go-tools-container

.PHONY: in-tools
in-tools:
	docker run --rm -it kamilsk/go-tools

.PHONY: in-tools-build-image
in-tools-build-image:
	docker run --rm -it go-tools-build-image

.PHONY: pack-tools
pack-tools: drop-tools
pack-tools:
	docker build -f $(CWD)/tools/pack.Dockerfile \
	             -t kamilsk/go-tools \
	             --force-rm --no-cache --pull --rm \
	             $(CWD)/tools

.PHONY: publish-tools
publish-tools:
	docker push kamilsk/go-tools

.PHONY: pull-tools
pull-tools:
	docker pull kamilsk/go-tools
