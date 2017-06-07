PROTOC = 3.3.1

.PHONY: build-proto-experiments
build-proto-experiments: build-proto-experiments-image
build-proto-experiments: get-proto-experiments-artifacts
build-proto-experiments: pack-proto-experiments
build-proto-experiments:
	make clean-experiments-artifacts
	make clean-proto-experiments-image

.PHONY: build-proto-experiments-image
build-proto-experiments-image: clean-proto-experiments-image
build-proto-experiments-image:
	docker build -f $(CWD)/experiments/build.proto.Dockerfile \
	             -t build-go-proto-experiments-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$$(docker images | grep '^alpine\s\+latest' | awk '{print $$3}') \
	             --build-arg VERSION=$(PROTOC) \
	             $(CWD)/experiments

.PHONY: clean-proto-experiments-image
clean-proto-experiments-image:
	docker rmi -f build-go-proto-experiments-image &>/dev/null || true

.PHONY: drop-proto-experiments
drop-proto-experiments: clean-invalid-experiments
drop-proto-experiments:
	docker images --all \
	| grep '^kamilsk\/go-experiments\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep 'latest' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: get-proto-experiments-artifacts
get-proto-experiments-artifacts: clean-experiments-artifacts
get-proto-experiments-artifacts:
	docker rm -f build-go-proto-experiments-container &>/dev/null || true
	mkdir -p $(CWD)/experiments/artifacts
	docker create --name build-go-proto-experiments-container build-go-proto-experiments-image
	docker cp build-go-proto-experiments-container:/usr/local/bin/protoc $(CWD)/experiments/artifacts/
	docker cp build-go-proto-experiments-container:/tmp/go-protobuf      $(CWD)/experiments/artifacts/
	docker cp build-go-proto-experiments-container:/tmp/gogo-protobuf    $(CWD)/experiments/artifacts/
	docker cp build-go-proto-experiments-container:/tmp/meta.data        $(CWD)/experiments/artifacts/
	cat $(CWD)/experiments/artifacts/meta.data | sed '/START METADATA/d' | sed '/END METADATA/d' | sed 's/[ ]*$$//' \
	  > $(CWD)/experiments/latest.log
	docker rm -f build-go-proto-experiments-container

.PHONY: in-proto-experiments
in-proto-experiments:
	docker run --rm -it kamilsk/go-experiments:latest /bin/sh

.PHONY: in-proto-experiments-image
in-proto-experiments-image:
	docker run --rm -it build-go-proto-experiments-image

.PHONY: pack-proto-experiments
pack-proto-experiments: drop-proto-experiments
pack-proto-experiments:
	docker build -f $(CWD)/experiments/pack.proto.Dockerfile \
	             -t kamilsk/go-experiments:latest \
	             --force-rm --no-cache --pull --rm \
	             $(CWD)/experiments

### [kamilsk/go-protobuf](https://hub.docker.com/r/kamilsk/go-protobuf/)
