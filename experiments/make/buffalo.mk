BUFFALO = 0.9.5

.PHONY: build-buffalo
build-buffalo: build-buffalo-image
build-buffalo: get-buffalo-artifacts
build-buffalo: pack-buffalo
build-buffalo:
	make clean-buffalo-artifacts
	make clean-buffalo-build-image

.PHONY: build-buffalo-image
build-buffalo-image: clean-buffalo-build-image
build-buffalo-image:
	docker build -f $(CWD)/experiments/docker/build.buffalo.Dockerfile \
	             -t go-buffalo-experiments-build-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$$(docker images | grep '^golang\s\+alpine' | awk '{print $$3}') \
	             --build-arg VERSION=$(BUFFALO) \
	             $(CWD)/experiments

.PHONY: clean-buffalo-artifacts
clean-buffalo-artifacts:
	rm -rf $(CWD)/experiments/artifacts/buffalo &>/dev/null || true

.PHONY: clean-buffalo-build-image
clean-buffalo-build-image:
	docker rmi -f go-buffalo-experiments-build-image &>/dev/null || true

.PHONY: drop-buffalo
drop-buffalo: clean-invalid-experiments
drop-buffalo:
	docker images --all \
	| grep '^kamilsk\/go-experiments\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep 'buffalo' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: get-buffalo-artifacts
get-buffalo-artifacts: clean-buffalo-artifacts
get-buffalo-artifacts:
	docker rm -f go-buffalo-experiments-container &>/dev/null || true
	mkdir -p $(CWD)/experiments/artifacts
	docker create --name go-buffalo-experiments-container go-buffalo-experiments-build-image
	docker cp go-buffalo-experiments-container:/tmp/buffalo   $(CWD)/experiments/artifacts/
	docker cp go-buffalo-experiments-container:/tmp/meta.data $(CWD)/experiments/artifacts/
	cat $(CWD)/experiments/artifacts/meta.data | sed '/START METADATA/d' | sed '/END METADATA/d' | sed 's/[ ]*$$//' \
	  > $(CWD)/experiments/buffalo.log
	docker rm -f go-buffalo-experiments-container

.PHONY: in-buffalo
in-buffalo:
	docker run --rm -it kamilsk/go-experiments:buffalo /bin/sh

.PHONY: in-buffalo-image
in-buffalo-image:
	docker run --rm -it go-buffalo-experiments-build-image

.PHONY: pack-buffalo
pack-buffalo: drop-buffalo
pack-buffalo:
	docker build -f $(CWD)/experiments/docker/pack.buffalo.Dockerfile \
	             -t kamilsk/go-experiments:buffalo \
	             --force-rm --no-cache --pull --rm \
	             $(CWD)/experiments

.PHONY: publish-buffalo
publish-buffalo:
	docker push kamilsk/go-experiments:buffalo

.PHONY: pull-buffalo
pull-buffalo:
	docker pull kamilsk/go-experiments:buffalo

### [kamilsk/buffalo](https://hub.docker.com/r/kamilsk/buffalo/)
