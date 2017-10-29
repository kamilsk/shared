.PHONY: build-dep
build-dep: build-dep-image
build-dep: get-dep-artifacts

.PHONY: build-dep-image
build-dep-image: clean-dep-build-image
build-dep-image:
	docker build -f $(CWD)/tools/docker/build.dep.Dockerfile \
	             -t go-tools_dep_build-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg VERSION=$(DEP) \
	             $(CWD)/tools

.PHONY: clean-dep-artifacts
clean-dep-artifacts:
	rm -rf $(CWD)/tools/artifacts/dep &>/dev/null || true

.PHONY: clean-dep-build-image
clean-dep-build-image:
	docker rmi -f go-tools_dep_build-image &>/dev/null || true

.PHONY: get-dep-artifacts
get-dep-artifacts: clean-dep-artifacts
get-dep-artifacts:
	docker rm -f go-tools_dep_build-container &>/dev/null || true
	mkdir -p $(CWD)/tools/artifacts/dep
	docker create --name go-tools_dep_build-container go-tools_dep_build-image
	docker cp go-tools_dep_build-container:/tmp/dep       $(CWD)/tools/artifacts/dep/
	docker cp go-tools_dep_build-container:/tmp/meta.data $(CWD)/tools/artifacts/dep.metadata
	docker rm -f go-tools_dep_build-container

.PHONY: in-dep-build-image
in-dep-build-image:
	if docker images --all | grep go-tools_dep_build-image; then \
		docker run --rm -it go-tools_dep_build-image; \
	else \
		echo Build image not found; \
	fi
