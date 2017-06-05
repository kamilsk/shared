DEPTH    = 1.1.1
REPORTER = 2.1.0

.PHONY: build-experimental-tools
build-experimental-tools: build-experimental-tools-image
build-experimental-tools: get-experimental-tools-artifacts
build-experimental-tools: pack-experimental-tools
build-experimental-tools:
	make clean-tools-artifacts
	make clean-experimental-tools-image

.PHONY: build-experimental-tools-image
build-experimental-tools-image: clean-experimental-tools-image
build-experimental-tools-image:
	docker build -f $(CWD)/tools/build.exp.Dockerfile \
	             -t build-experimental-go-tools-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$$(docker images | grep '^golang\s\+alpine' | awk '{print $$3}') \
	             --build-arg DEPTH=$(DEPTH) \
	             --build-arg REPORTER=$(REPORTER) \
	             $(CWD)/tools

.PHONY: clean-experimental-tools-image
clean-experimental-tools-image:
	docker rmi -f build-experimental-go-tools-image &>/dev/null || true

.PHONY: drop-experimental-tools
drop-experimental-tools: clean-invalid-tools
drop-experimental-tools:
	docker images --all \
	| grep '^kamilsk\/go-tools\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep 'experimental' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: get-experimental-tools-artifacts
get-experimental-tools-artifacts: clean-tools-artifacts
get-experimental-tools-artifacts:
	docker rm -f build-experimental-go-tools-container &>/dev/null || true
	mkdir -p $(CWD)/tools/artifacts
	docker create --name build-experimental-go-tools-container build-experimental-go-tools-image
	docker cp build-experimental-go-tools-container:/tmp/apicompat  $(CWD)/tools/artifacts/
	docker cp build-experimental-go-tools-container:/tmp/benchcmp   $(CWD)/tools/artifacts/
	docker cp build-experimental-go-tools-container:/tmp/depth      $(CWD)/tools/artifacts/
	docker cp build-experimental-go-tools-container:/tmp/godepq     $(CWD)/tools/artifacts/
	docker cp build-experimental-go-tools-container:/tmp/goreporter $(CWD)/tools/artifacts/
	docker cp build-experimental-go-tools-container:/tmp/honnef     $(CWD)/tools/artifacts/
	docker cp build-experimental-go-tools-container:/tmp/zb         $(CWD)/tools/artifacts/
	docker cp build-experimental-go-tools-container:/tmp/meta.data  $(CWD)/tools/artifacts/
	cat $(CWD)/tools/artifacts/meta.data | sed '/START METADATA/d' | sed '/END METADATA/d' | sed 's/[ ]*$$//' \
	  > $(CWD)/tools/experimental.log
	docker rm -f build-experimental-go-tools-container

.PHONY: in-experimental-tools
in-experimental-tools:
	docker run --rm -it kamilsk/go-tools:experimental

.PHONY: in-experimental-tools-image
in-experimental-tools-image:
	docker run --rm -it build-experimental-go-tools-image

.PHONY: pack-experimental-tools
pack-experimental-tools: drop-experimental-tools
pack-experimental-tools:
	docker build -f $(CWD)/tools/pack.exp.Dockerfile \
	             -t kamilsk/go-tools:experimental \
	             --force-rm --no-cache --pull --rm \
	             $(CWD)/tools

.PHONY: publish-experimental-tools
publish-experimental-tools:
	docker push kamilsk/go-tools:experimental
