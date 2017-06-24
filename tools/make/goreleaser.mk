.PHONY: build-goreleaser
build-goreleaser: build-goreleaser-image
build-goreleaser: get-goreleaser-artifacts

.PHONY: build-goreleaser-image
build-goreleaser-image: clean-goreleaser-build-image
build-goreleaser-image:
	docker build -f $(CWD)/tools/docker/build.goreleaser.Dockerfile \
	             -t go-tools_goreleaser_build-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg VERSION=$(RELEASER) \
	             $(CWD)/tools

.PHONY: clean-goreleaser-artifacts
clean-goreleaser-artifacts:
	rm -rf $(CWD)/tools/artifacts/goreleaser &>/dev/null || true

.PHONY: clean-goreleaser-build-image
clean-goreleaser-build-image:
	docker rmi -f go-tools_goreleaser_build-image &>/dev/null || true

.PHONY: get-goreleaser-artifacts
get-goreleaser-artifacts: clean-goreleaser-artifacts
get-goreleaser-artifacts:
	docker rm -f go-tools_goreleaser_build-container &>/dev/null || true
	mkdir -p $(CWD)/tools/artifacts/goreleaser
	docker create --name go-tools_goreleaser_build-container go-tools_goreleaser_build-image
	docker cp go-tools_goreleaser_build-container:/tmp/goreleaser $(CWD)/tools/artifacts/
	docker cp go-tools_goreleaser_build-container:/tmp/meta.data  $(CWD)/tools/artifacts/goreleaser.metadata
	docker rm -f go-tools_goreleaser_build-container

.PHONY: in-goreleaser-build-image
in-goreleaser-build-image:
	if docker images --all | grep go-tools_goreleaser_build-image; then \
		docker run --rm -it go-tools_goreleaser_build-image; \
	else \
		echo Build image not found; \
	fi
