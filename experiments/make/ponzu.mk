PONZU = 0.9.2

.PHONY: build-ponzu
build-ponzu: build-ponzu-image
build-ponzu: get-ponzu-artifacts
build-ponzu: pack-ponzu
build-ponzu:
	make clean-ponzu-artifacts
	make clean-ponzu-build-image

.PHONY: build-ponzu-image
build-ponzu-image: clean-ponzu-build-image
build-ponzu-image:
	docker build -f $(CWD)/experiments/docker/build.ponzu.Dockerfile \
	             -t go-ponzu-experiments-build-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$$(docker images | grep '^golang\s\+alpine' | awk '{print $$3}') \
	             --build-arg VERSION=$(PONZU) \
	             $(CWD)/experiments

.PHONY: clean-ponzu-artifacts
clean-ponzu-artifacts:
	rm -rf $(CWD)/experiments/artifacts/ponzu &>/dev/null || true

.PHONY: clean-ponzu-build-image
clean-ponzu-build-image:
	docker rmi -f go-ponzu-experiments-build-image &>/dev/null || true

.PHONY: drop-ponzu
drop-ponzu: clean-invalid-experiments
drop-ponzu:
	docker images --all \
	| grep '^kamilsk\/go-experiments\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep 'ponzu' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: get-ponzu-artifacts
get-ponzu-artifacts: clean-ponzu-artifacts
get-ponzu-artifacts:
	docker rm -f go-ponzu-experiments-container &>/dev/null || true
	mkdir -p $(CWD)/experiments/artifacts
	docker create --name go-ponzu-experiments-container go-ponzu-experiments-build-image
	docker cp go-ponzu-experiments-container:/tmp/ponzu     $(CWD)/experiments/artifacts/
	docker cp go-ponzu-experiments-container:/tmp/meta.data $(CWD)/experiments/artifacts/
	cat $(CWD)/experiments/artifacts/meta.data | sed '/START METADATA/d' | sed '/END METADATA/d' | sed 's/[ ]*$$//' \
	  > $(CWD)/experiments/ponzu.log
	docker rm -f go-ponzu-experiments-container

.PHONY: in-ponzu
in-ponzu:
	docker run --rm -it kamilsk/go-experiments:ponzu /bin/sh

.PHONY: in-ponzu-image
in-ponzu-image:
	docker run --rm -it go-ponzu-experiments-build-image

.PHONY: pack-ponzu
pack-ponzu: drop-ponzu
pack-ponzu:
	docker build -f $(CWD)/experiments/docker/pack.ponzu.Dockerfile \
	             -t kamilsk/go-experiments:ponzu \
	             --force-rm --no-cache --pull --rm \
	             $(CWD)/experiments

.PHONY: publish-ponzu
publish-ponzu:
	docker push kamilsk/go-experiments:ponzu

.PHONY: pull-ponzu
pull-ponzu:
	docker pull kamilsk/go-experiments:ponzu

### [kamilsk/ponzu](https://hub.docker.com/r/kamilsk/ponzu/)
