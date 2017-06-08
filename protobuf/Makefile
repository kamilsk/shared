PROTOC = 3.3.1

.PHONY: build-protobuf
build-protobuf: build-protobuf-image
build-protobuf: get-protobuf-artifacts
build-protobuf: pack-protobuf
build-protobuf:
	make clean-protobuf-artifacts
	make clean-protobuf-build-image

.PHONY: build-protobuf-image
build-protobuf-image: clean-protobuf-build-image
build-protobuf-image:
	docker build -f $(CWD)/protobuf/build.Dockerfile \
	             -t go-protobuf-build-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$$(docker images | grep '^alpine\s\+latest' | awk '{print $$3}') \
	             --build-arg VERSION=$(PROTOC) \
	             $(CWD)/protobuf

.PHONY: clean-invalid-protobuf
clean-invalid-protobuf:
	docker images --all \
	| grep '^kamilsk\/go-protobuf\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep '^<none>\s\+' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: clean-protobuf-artifacts
clean-protobuf-artifacts:
	rm -rf $(CWD)/protobuf/artifacts &>/dev/null || true

.PHONY: clean-protobuf-build-image
clean-protobuf-build-image:
	docker rmi -f go-protobuf-build-image &>/dev/null || true

.PHONY: drop-protobuf
drop-protobuf: clean-invalid-protobuf
drop-protobuf:
	docker images --all \
	| grep '^kamilsk\/go-protobuf\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep 'latest' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: get-protobuf-artifacts
get-protobuf-artifacts: clean-protobuf-artifacts
get-protobuf-artifacts:
	docker rm -f go-protobuf-container &>/dev/null || true
	mkdir -p $(CWD)/protobuf/artifacts
	docker create --name go-protobuf-container go-protobuf-build-image
	docker cp go-protobuf-container:/usr/local/bin/protoc $(CWD)/protobuf/artifacts/
	docker cp go-protobuf-container:/tmp/go-protobuf      $(CWD)/protobuf/artifacts/
	docker cp go-protobuf-container:/tmp/gogo-protobuf    $(CWD)/protobuf/artifacts/
	docker cp go-protobuf-container:/tmp/meta.data        $(CWD)/protobuf/artifacts/
	cat $(CWD)/protobuf/artifacts/meta.data | sed '/START METADATA/d' | sed '/END METADATA/d' | sed 's/[ ]*$$//' \
	  > $(CWD)/protobuf/latest.log
	docker rm -f go-protobuf-container

.PHONY: in-protobuf
in-protobuf:
	docker run --rm -it kamilsk/go-protobuf /bin/sh

.PHONY: in-protobuf-build-image
in-protobuf-build-image:
	docker run --rm -it go-protobuf-build-image

.PHONY: pack-protobuf
pack-protobuf: drop-protobuf
pack-protobuf:
	docker build -f $(CWD)/protobuf/pack.Dockerfile \
	             -t kamilsk/go-protobuf \
	             --force-rm --no-cache --pull --rm \
	             $(CWD)/protobuf

.PHONY: publish-protobuf
publish-protobuf:
	docker push kamilsk/go-protobuf

.PHONY: pull-protobuf
pull-protobuf:
	docker pull kamilsk/go-protobuf
