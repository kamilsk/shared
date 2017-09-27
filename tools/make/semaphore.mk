.PHONY: build-semaphore
build-semaphore: build-semaphore-image
build-semaphore: get-semaphore-artifacts

.PHONY: build-semaphore-image
build-semaphore-image: clean-semaphore-build-image
build-semaphore-image:
	docker build -f $(CWD)/tools/docker/build.semaphore.Dockerfile \
	             -t go-tools_semaphore_build-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg VERSION=$(SEMAPHORE) \
	             $(CWD)/tools

.PHONY: clean-semaphore-artifacts
clean-semaphore-artifacts:
	rm -rf $(CWD)/tools/artifacts/semaphore &>/dev/null || true

.PHONY: clean-semaphore-build-image
clean-semaphore-build-image:
	docker rmi -f go-tools_semaphore_build-image &>/dev/null || true

.PHONY: get-semaphore-artifacts
get-semaphore-artifacts: clean-semaphore-artifacts
get-semaphore-artifacts:
	docker rm -f go-tools_semaphore_build-container &>/dev/null || true
	mkdir -p $(CWD)/tools/artifacts/semaphore
	docker create --name go-tools_semaphore_build-container go-tools_semaphore_build-image
	docker cp go-tools_semaphore_build-container:/tmp/semaphore $(CWD)/tools/artifacts/
	docker cp go-tools_semaphore_build-container:/tmp/meta.data $(CWD)/tools/artifacts/semaphore.metadata
	docker rm -f go-tools_semaphore_build-container

.PHONY: in-semaphore-build-image
in-semaphore-build-image:
	if docker images --all | grep go-tools_semaphore_build-image; then \
		docker run --rm -it go-tools_semaphore_build-image; \
	else \
		echo Build image not found; \
	fi
