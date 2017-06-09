MAINTAINER = 1.0.4

.PHONY: build-maintainer
build-maintainer: build-maintainer-image
build-maintainer: get-maintainer-artifacts
build-maintainer: pack-maintainer
build-maintainer:
	make clean-maintainer-artifacts
	make clean-maintainer-build-image

.PHONY: build-maintainer-image
build-maintainer-image: clean-maintainer-build-image
build-maintainer-image:
	docker build -f $(CWD)/experiments/docker/build.maintainer.Dockerfile \
	             -t go-maintainer-experiments-build-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$$(docker images | grep '^golang\s\+alpine' | awk '{print $$3}') \
	             --build-arg MAINTAINER=$(MAINTAINER) \
	             $(CWD)/experiments

.PHONY: clean-maintainer-artifacts
clean-maintainer-artifacts:
	rm -rf $(CWD)/experiments/artifacts/maintainer &>/dev/null || true

.PHONY: clean-maintainer-build-image
clean-maintainer-build-image:
	docker rmi -f go-maintainer-experiments-build-image &>/dev/null || true

.PHONY: drop-maintainer
drop-maintainer: clean-invalid-experiments
drop-maintainer:
	docker images --all \
	| grep '^kamilsk\/go-experiments\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep 'maintainer' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: get-maintainer-artifacts
get-maintainer-artifacts: clean-maintainer-artifacts
get-maintainer-artifacts:
	docker rm -f go-maintainer-experiments-container &>/dev/null || true
	mkdir -p $(CWD)/experiments/artifacts
	docker create --name go-maintainer-experiments-container go-maintainer-experiments-build-image
	docker cp go-maintainer-experiments-container:/tmp/maintainer $(CWD)/experiments/artifacts/
	docker cp go-maintainer-experiments-container:/tmp/meta.data  $(CWD)/experiments/artifacts/
	cat $(CWD)/experiments/artifacts/meta.data | sed '/START METADATA/d' | sed '/END METADATA/d' | sed 's/[ ]*$$//' \
	  > $(CWD)/experiments/maintainer.log
	docker rm -f go-maintainer-experiments-container

.PHONY: in-maintainer
in-maintainer:
	docker run --rm -it kamilsk/go-experiments:maintainer

.PHONY: in-maintainer-image
in-maintainer-image:
	docker run --rm -it go-maintainer-experiments-build-image

.PHONY: pack-maintainer
pack-maintainer: drop-maintainer
pack-maintainer:
	docker build -f $(CWD)/experiments/docker/pack.maintainer.Dockerfile \
	             -t kamilsk/go-experiments:maintainer \
	             --force-rm --no-cache --pull --rm \
	             $(CWD)/experiments

.PHONY: publish-maintainer
publish-maintainer:
	docker push kamilsk/go-experiments:maintainer

.PHONY: pull-maintainer
pull-maintainer:
	docker pull kamilsk/go-experiments:maintainer
