PROTOC = 3.3.1

.PHONY: build-experiments
build-experiments: build-experiments-image
build-experiments: get-experiments-artifacts
build-experiments: pack-experiments
build-experiments:
	make clean-experiments-artifacts
	make clean-experiments-image

.PHONY: build-experiments-image
build-experiments-image: clean-experiments-image
build-experiments-image:
	docker build -f $(CWD)/experiments/build.Dockerfile \
	             -t build-go-experiments-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$$(docker images | grep '^alpine\s\+latest' | awk '{print $$3}') \
	             --build-arg VERSION=$(PROTOC) \
	             $(CWD)/experiments

.PHONY: clean-invalid-experiments
clean-invalid-experiments:
	docker images --all \
	| grep '^kamilsk\/go-experiments\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep '^<none>\s\+' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: clean-experiments-artifacts
clean-experiments-artifacts:
	rm -rf $(CWD)/experiments/artifacts &>/dev/null || true

.PHONY: clean-experiments-image
clean-experiments-image:
	docker rmi -f build-go-experiments-image &>/dev/null || true

.PHONY: drop-experiments
drop-experiments: clean-invalid-experiments
drop-experiments:
	docker images --all \
	| grep '^kamilsk\/go-experiments\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep 'latest' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: get-experiments-artifacts
get-experiments-artifacts: clean-experiments-artifacts
get-experiments-artifacts:
	docker rm -f build-go-experiments-container &>/dev/null || true
	mkdir -p $(CWD)/experiments/artifacts
	docker create --name build-go-experiments-container build-go-experiments-image
	docker cp build-go-experiments-container:/usr/local/bin/protoc $(CWD)/experiments/artifacts/
	docker cp build-go-experiments-container:/tmp/go-protobuf      $(CWD)/experiments/artifacts/
	docker cp build-go-experiments-container:/tmp/gogo-protobuf    $(CWD)/experiments/artifacts/
	docker cp build-go-experiments-container:/tmp/meta.data        $(CWD)/experiments/artifacts/
	cat $(CWD)/experiments/artifacts/meta.data | sed '/START METADATA/d' | sed '/END METADATA/d' | sed 's/[ ]*$$//' \
	  > $(CWD)/experiments/latest.log
	docker rm -f build-go-experiments-container

.PHONY: in-experiments
in-experiments:
	docker run --rm -it kamilsk/go-experiments:latest /bin/sh

.PHONY: in-experiments-image
in-experiments-image:
	docker run --rm -it build-go-experiments-image

.PHONY: pack-experiments
pack-experiments: drop-experiments
pack-experiments:
	docker build -f $(CWD)/experiments/pack.Dockerfile \
	             -t kamilsk/go-experiments:latest \
	             --force-rm --no-cache --pull --rm \
	             $(CWD)/experiments

### [kamilsk/go-protobuf](https://hub.docker.com/r/kamilsk/go-protobuf/)
