.PHONY: build-gometalinter
build-gometalinter: build-gometalinter-image
build-gometalinter: get-gometalinter-artifacts

.PHONY: build-gometalinter-image
build-gometalinter-image: clean-gometalinter-build-image
build-gometalinter-image:
	docker build -f $(CWD)/tools/docker/build.gometalinter.Dockerfile \
	             -t go-tools_gometalinter_build-image \
	             --force-rm --no-cache --pull --rm \
	             $(CWD)/tools

.PHONY: clean-gometalinter-artifacts
clean-gometalinter-artifacts:
	rm -rf $(CWD)/tools/artifacts/gometalinter &>/dev/null || true

.PHONY: clean-gometalinter-build-image
clean-gometalinter-build-image:
	docker rmi -f go-tools_gometalinter_build-image &>/dev/null || true

.PHONY: get-gometalinter-artifacts
get-gometalinter-artifacts: clean-gometalinter-artifacts
get-gometalinter-artifacts:
	docker rm -f go-tools_gometalinter_build-container &>/dev/null || true
	mkdir -p $(CWD)/tools/artifacts/gometalinter
	docker create --name go-tools_gometalinter_build-container go-tools_gometalinter_build-image
	docker cp go-tools_gometalinter_build-container:/tmp/gometalinter $(CWD)/tools/artifacts/
	docker cp go-tools_gometalinter_build-container:/tmp/meta.data    $(CWD)/tools/artifacts/gometalinter.metadata
	docker rm -f go-tools_gometalinter_build-container

.PHONY: in-gometalinter-build-image
in-gometalinter-build-image:
	if docker images --all | grep go-tools_gometalinter_build-image; then \
		docker run --rm -it go-tools_gometalinter_build-image; \
	else \
		echo Build image not found; \
	fi
