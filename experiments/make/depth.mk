DEPTH = 1.1.1

.PHONY: build-depth
build-depth: build-depth-image
build-depth: get-depth-artifacts
build-depth: pack-depth
build-depth:
	make clean-depth-artifacts
	make clean-depth-build-image

.PHONY: build-depth-image
build-depth-image: clean-depth-build-image
build-depth-image:
	docker build -f $(CWD)/experiments/docker/build.depth.Dockerfile \
	             -t go-depth-experiments-build-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$$(docker images | grep '^golang\s\+alpine' | awk '{print $$3}') \
	             --build-arg DEPTH=$(DEPTH) \
	             $(CWD)/experiments

.PHONY: clean-depth-artifacts
clean-depth-artifacts:
	rm -rf $(CWD)/experiments/artifacts/depth &>/dev/null || true

.PHONY: clean-depth-build-image
clean-depth-build-image:
	docker rmi -f go-depth-experiments-build-image &>/dev/null || true

.PHONY: drop-depth
drop-depth: clean-invalid-experiments
drop-depth:
	docker images --all \
	| grep '^kamilsk\/go-experiments\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep 'depth' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: get-depth-artifacts
get-depth-artifacts: clean-depth-artifacts
get-depth-artifacts:
	docker rm -f go-depth-experiments-container &>/dev/null || true
	mkdir -p $(CWD)/experiments/artifacts
	docker create --name go-depth-experiments-container go-depth-experiments-build-image
	docker cp go-depth-experiments-container:/tmp/depth     $(CWD)/experiments/artifacts/
	docker cp go-depth-experiments-container:/tmp/meta.data $(CWD)/experiments/artifacts/
	cat $(CWD)/experiments/artifacts/meta.data | sed '/START METADATA/d' | sed '/END METADATA/d' | sed 's/[ ]*$$//' \
	  > $(CWD)/experiments/depth.log
	docker rm -f go-depth-experiments-container

.PHONY: in-depth
in-depth:
	docker run --rm -it kamilsk/go-experiments:depth

.PHONY: in-depth-image
in-depth-image:
	docker run --rm -it go-depth-experiments-build-image

.PHONY: pack-depth
pack-depth: drop-depth
pack-depth:
	docker build -f $(CWD)/experiments/docker/pack.depth.Dockerfile \
	             -t kamilsk/go-experiments:depth \
	             --force-rm --no-cache --pull --rm \
	             $(CWD)/experiments

.PHONY: publish-depth
publish-depth:
	docker push kamilsk/go-experiments:depth

.PHONY: pull-depth
pull-depth:
	docker pull kamilsk/go-experiments:depth
