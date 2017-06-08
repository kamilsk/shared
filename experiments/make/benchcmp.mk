.PHONY: build-benchcmp
build-benchcmp: build-benchcmp-image
build-benchcmp: get-benchcmp-artifacts
build-benchcmp: pack-benchcmp
build-benchcmp:
	make clean-benchcmp-artifacts
	make clean-benchcmp-build-image

.PHONY: build-benchcmp-image
build-benchcmp-image: clean-benchcmp-build-image
build-benchcmp-image:
	docker build -f $(CWD)/experiments/docker/build.benchcmp.Dockerfile \
	             -t go-benchcmp-experiments-build-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$$(docker images | grep '^golang\s\+alpine' | awk '{print $$3}') \
	             $(CWD)/experiments

.PHONY: clean-benchcmp-artifacts
clean-benchcmp-artifacts:
	rm -rf $(CWD)/experiments/artifacts/benchcmp &>/dev/null || true

.PHONY: clean-benchcmp-build-image
clean-benchcmp-build-image:
	docker rmi -f go-benchcmp-experiments-build-image &>/dev/null || true

.PHONY: drop-benchcmp
drop-benchcmp: clean-invalid-experiments
drop-benchcmp:
	docker images --all \
	| grep '^kamilsk\/go-experiments\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep 'benchcmp' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: get-benchcmp-artifacts
get-benchcmp-artifacts: clean-benchcmp-artifacts
get-benchcmp-artifacts:
	docker rm -f go-benchcmp-experiments-container &>/dev/null || true
	mkdir -p $(CWD)/experiments/artifacts
	docker create --name go-benchcmp-experiments-container go-benchcmp-experiments-build-image
	docker cp go-benchcmp-experiments-container:/tmp/benchcmp  $(CWD)/experiments/artifacts/
	docker cp go-benchcmp-experiments-container:/tmp/meta.data $(CWD)/experiments/artifacts/
	cat $(CWD)/experiments/artifacts/meta.data | sed '/START METADATA/d' | sed '/END METADATA/d' | sed 's/[ ]*$$//' \
	  > $(CWD)/experiments/benchcmp.log
	docker rm -f go-benchcmp-experiments-container

.PHONY: in-benchcmp
in-benchcmp:
	docker run --rm -it kamilsk/go-experiments:benchcmp

.PHONY: in-benchcmp-image
in-benchcmp-image:
	docker run --rm -it go-benchcmp-experiments-build-image

.PHONY: pack-benchcmp
pack-benchcmp: drop-benchcmp
pack-benchcmp:
	docker build -f $(CWD)/experiments/docker/pack.benchcmp.Dockerfile \
	             -t kamilsk/go-experiments:benchcmp \
	             --force-rm --no-cache --pull --rm \
	             $(CWD)/experiments

.PHONY: publish-benchcmp
publish-benchcmp:
	docker push kamilsk/go-experiments:benchcmp

.PHONY: pull-benchcmp
pull-benchcmp:
	docker pull kamilsk/go-experiments:benchcmp
