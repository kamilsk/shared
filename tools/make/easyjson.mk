.PHONY: build-easyjson
build-easyjson: build-easyjson-image
build-easyjson: get-easyjson-artifacts

.PHONY: build-easyjson-image
build-easyjson-image: clean-easyjson-build-image
build-easyjson-image:
	docker build -f $(CWD)/tools/docker/build.easyjson.Dockerfile \
	             -t go-tools_easyjson_build-image \
	             --force-rm --no-cache --pull --rm \
	             $(CWD)/tools

.PHONY: clean-easyjson-artifacts
clean-easyjson-artifacts:
	rm -rf $(CWD)/tools/artifacts/easyjson &>/dev/null || true

.PHONY: clean-easyjson-build-image
clean-easyjson-build-image:
	docker rmi -f go-tools_easyjson_build-image &>/dev/null || true

.PHONY: get-easyjson-artifacts
get-easyjson-artifacts: clean-easyjson-artifacts
get-easyjson-artifacts:
	docker rm -f go-tools_easyjson_build-container &>/dev/null || true
	mkdir -p $(CWD)/tools/artifacts/easyjson
	docker create --name go-tools_easyjson_build-container go-tools_easyjson_build-image
	docker cp go-tools_easyjson_build-container:/tmp/easyjson  $(CWD)/tools/artifacts/
	docker cp go-tools_easyjson_build-container:/tmp/meta.data $(CWD)/tools/artifacts/easyjson.metadata
	docker rm -f go-tools_easyjson_build-container

.PHONY: in-easyjson-build-image
in-easyjson-build-image:
	if docker images --all | grep go-tools_easyjson_build-image; then \
		docker run --rm -it go-tools_easyjson_build-image; \
	else \
		echo Build image not found; \
	fi
