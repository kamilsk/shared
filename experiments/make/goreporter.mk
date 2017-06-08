REPORTER = 2.1.0

.PHONY: build-goreporter
build-goreporter: build-goreporter-image
build-goreporter: get-goreporter-artifacts
build-goreporter: pack-goreporter
build-goreporter:
	make clean-goreporter-artifacts
	make clean-goreporter-build-image

.PHONY: build-goreporter-image
build-goreporter-image: clean-goreporter-build-image
build-goreporter-image:
	docker build -f $(CWD)/experiments/docker/build.goreporter.Dockerfile \
	             -t go-goreporter-experiments-build-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$$(docker images | grep '^golang\s\+alpine' | awk '{print $$3}') \
	             --build-arg REPORTER=$(REPORTER) \
	             $(CWD)/experiments

.PHONY: clean-goreporter-artifacts
clean-goreporter-artifacts:
	rm -rf $(CWD)/experiments/artifacts/goreporter &>/dev/null || true

.PHONY: clean-goreporter-build-image
clean-goreporter-build-image:
	docker rmi -f go-goreporter-experiments-build-image &>/dev/null || true

.PHONY: drop-goreporter
drop-goreporter: clean-invalid-experiments
drop-goreporter:
	docker images --all \
	| grep '^kamilsk\/go-experiments\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep 'goreporter' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: get-goreporter-artifacts
get-goreporter-artifacts: clean-goreporter-artifacts
get-goreporter-artifacts:
	docker rm -f go-goreporter-experiments-container &>/dev/null || true
	mkdir -p $(CWD)/experiments/artifacts
	docker create --name go-goreporter-experiments-container go-goreporter-experiments-build-image
	docker cp go-goreporter-experiments-container:/tmp/goreporter $(CWD)/experiments/artifacts/
	docker cp go-goreporter-experiments-container:/tmp/meta.data  $(CWD)/experiments/artifacts/
	cat $(CWD)/experiments/artifacts/meta.data | sed '/START METADATA/d' | sed '/END METADATA/d' | sed 's/[ ]*$$//' \
	  > $(CWD)/experiments/goreporter.log
	docker rm -f go-goreporter-experiments-container

.PHONY: in-goreporter
in-goreporter:
	docker run --rm -it kamilsk/go-experiments:goreporter

.PHONY: in-goreporter-image
in-goreporter-image:
	docker run --rm -it go-goreporter-experiments-build-image

.PHONY: pack-goreporter
pack-goreporter: drop-goreporter
pack-goreporter:
	docker build -f $(CWD)/experiments/docker/pack.goreporter.Dockerfile \
	             -t kamilsk/go-experiments:goreporter \
	             --force-rm --no-cache --pull --rm \
	             $(CWD)/experiments

.PHONY: publish-goreporter
publish-goreporter:
	docker push kamilsk/go-experiments:goreporter

.PHONY: pull-goreporter
pull-goreporter:
	docker pull kamilsk/go-experiments:goreporter
