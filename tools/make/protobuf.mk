.PHONY: build-protobuf
build-protobuf: build-protobuf-image
build-protobuf: get-protobuf-artifacts

.PHONY: build-protobuf-image
build-protobuf-image: clean-protobuf-build-image
build-protobuf-image:
	docker build -f $(CWD)/tools/docker/build.protobuf.Dockerfile \
	             -t go-tools_protobuf_build-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg VERSION=$(PROTOC) \
	             $(CWD)/tools

.PHONY: clean-protobuf-artifacts
clean-protobuf-artifacts:
	rm -rf $(CWD)/tools/artifacts/protobuf &>/dev/null || true

.PHONY: clean-protobuf-build-image
clean-protobuf-build-image:
	docker rmi -f go-tools_protobuf_build-image &>/dev/null || true

.PHONY: get-protobuf-artifacts
get-protobuf-artifacts: clean-protobuf-artifacts
get-protobuf-artifacts:
	docker rm -f go-tools_protobuf_build-container &>/dev/null || true
	mkdir -p $(CWD)/tools/artifacts/protobuf
	docker create --name go-tools_protobuf_build-container go-tools_protobuf_build-image
	docker cp go-tools_protobuf_build-container:/tmp/protoc        $(CWD)/tools/artifacts/protobuf/
	docker cp go-tools_protobuf_build-container:/tmp/go-protobuf   $(CWD)/tools/artifacts/protobuf/
	docker cp go-tools_protobuf_build-container:/tmp/gogo-protobuf $(CWD)/tools/artifacts/protobuf/
	docker cp go-tools_protobuf_build-container:/tmp/meta.data     $(CWD)/tools/artifacts/protobuf.metadata
	docker rm -f go-tools_protobuf_build-container

.PHONY: in-protobuf-build-image
in-protobuf-build-image:
	if docker images --all | grep go-tools_protobuf_build-image; then \
		docker run --rm -it go-tools_protobuf_build-image; \
	else \
		echo Build image not found; \
	fi
