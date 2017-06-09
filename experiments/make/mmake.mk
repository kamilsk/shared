# https://github.com/tj/mmake
# - https://github.com/KyleBanks/make
# - https://github.com/KyleBanks/depth/blob/master/Makefile

MMAKE = 1.2.0

.PHONY: build-mmake
build-mmake: build-mmake-image
build-mmake: get-mmake-artifacts
build-mmake: pack-mmake
build-mmake:
	make clean-mmake-artifacts
	make clean-mmake-build-image

.PHONY: build-mmake-image
build-mmake-image: clean-mmake-build-image
build-mmake-image:
	docker build -f $(CWD)/experiments/docker/build.mmake.Dockerfile \
	             -t go-mmake-experiments-build-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$$(docker images | grep '^golang\s\+alpine' | awk '{print $$3}') \
	             --build-arg MMAKE=$(MMAKE) \
	             $(CWD)/experiments

.PHONY: clean-mmake-artifacts
clean-mmake-artifacts:
	rm -rf $(CWD)/experiments/artifacts/mmake &>/dev/null || true

.PHONY: clean-mmake-build-image
clean-mmake-build-image:
	docker rmi -f go-mmake-experiments-build-image &>/dev/null || true

.PHONY: drop-mmake
drop-mmake: clean-invalid-experiments
drop-mmake:
	docker images --all \
	| grep '^kamilsk\/go-experiments\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep 'mmake' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: get-mmake-artifacts
get-mmake-artifacts: clean-mmake-artifacts
get-mmake-artifacts:
	docker rm -f go-mmake-experiments-container &>/dev/null || true
	mkdir -p $(CWD)/experiments/artifacts
	docker create --name go-mmake-experiments-container go-mmake-experiments-build-image
	docker cp go-mmake-experiments-container:/tmp/mmake $(CWD)/experiments/artifacts/
	docker cp go-mmake-experiments-container:/tmp/meta.data  $(CWD)/experiments/artifacts/
	cat $(CWD)/experiments/artifacts/meta.data | sed '/START METADATA/d' | sed '/END METADATA/d' | sed 's/[ ]*$$//' \
	  > $(CWD)/experiments/mmake.log
	docker rm -f go-mmake-experiments-container

.PHONY: in-mmake
in-mmake:
	docker run --rm -it kamilsk/go-experiments:mmake

.PHONY: in-mmake-image
in-mmake-image:
	docker run --rm -it go-mmake-experiments-build-image

.PHONY: pack-mmake
pack-mmake: drop-mmake
pack-mmake:
	docker build -f $(CWD)/experiments/docker/pack.mmake.Dockerfile \
	             -t kamilsk/go-experiments:mmake \
	             --force-rm --no-cache --pull --rm \
	             $(CWD)/experiments

.PHONY: publish-mmake
publish-mmake:
	docker push kamilsk/go-experiments:mmake

.PHONY: pull-mmake
pull-mmake:
	docker pull kamilsk/go-experiments:mmake
