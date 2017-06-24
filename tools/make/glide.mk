.PHONY: build-glide
build-glide: build-glide-image
build-glide: get-glide-artifacts

.PHONY: build-glide-image
build-glide-image: clean-glide-build-image
build-glide-image:
	docker build -f $(CWD)/tools/docker/build.glide.Dockerfile \
	             -t go-tools_glide_build-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg VERSION=$(GLIDE) \
	             $(CWD)/tools

.PHONY: clean-glide-artifacts
clean-glide-artifacts:
	rm -rf $(CWD)/tools/artifacts/glide &>/dev/null || true

.PHONY: clean-glide-build-image
clean-glide-build-image:
	docker rmi -f go-tools_glide_build-image &>/dev/null || true

.PHONY: get-glide-artifacts
get-glide-artifacts: clean-glide-artifacts
get-glide-artifacts:
	docker rm -f go-tools_glide_build-container &>/dev/null || true
	mkdir -p $(CWD)/tools/artifacts/glide
	docker create --name go-tools_glide_build-container go-tools_glide_build-image
	docker cp go-tools_glide_build-container:/tmp/glide     $(CWD)/tools/artifacts/
	docker cp go-tools_glide_build-container:/tmp/meta.data $(CWD)/tools/artifacts/glide.metadata
	docker rm -f go-tools_glide_build-container

.PHONY: in-glide-build-image
in-glide-build-image:
	if docker images --all | grep go-tools_glide_build-image; then \
		docker run --rm -it go-tools_glide_build-image; \
	else \
		echo Build image not found; \
	fi
