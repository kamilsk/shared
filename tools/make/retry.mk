.PHONY: build-retry
build-retry: build-retry-image
build-retry: get-retry-artifacts

.PHONY: build-retry-image
build-retry-image: clean-retry-build-image
build-retry-image:
	docker build -f $(CWD)/tools/docker/build.retry.Dockerfile \
	             -t go-tools_retry_build-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg VERSION=$(RETRY) \
	             $(CWD)/tools

.PHONY: clean-retry-artifacts
clean-retry-artifacts:
	rm -rf $(CWD)/tools/artifacts/retry &>/dev/null || true

.PHONY: clean-retry-build-image
clean-retry-build-image:
	docker rmi -f go-tools_retry_build-image &>/dev/null || true

.PHONY: get-retry-artifacts
get-retry-artifacts: clean-retry-artifacts
get-retry-artifacts:
	docker rm -f go-tools_retry_build-container &>/dev/null || true
	mkdir -p $(CWD)/tools/artifacts/retry
	docker create --name go-tools_retry_build-container go-tools_retry_build-image
	docker cp go-tools_retry_build-container:/tmp/retry     $(CWD)/tools/artifacts/
	docker cp go-tools_retry_build-container:/tmp/meta.data $(CWD)/tools/artifacts/retry.metadata
	docker rm -f go-tools_retry_build-container

.PHONY: in-retry-build-image
in-retry-build-image:
	if docker images --all | grep go-tools_retry_build-image; then \
		docker run --rm -it go-tools_retry_build-image; \
	else \
		echo Build image not found; \
	fi
