.PHONY: build-godepq
build-godepq: build-godepq-image
build-godepq: get-godepq-artifacts
build-godepq: pack-godepq
build-godepq:
	make clean-godepq-artifacts
	make clean-godepq-build-image

.PHONY: build-godepq-image
build-godepq-image: clean-godepq-build-image
build-godepq-image:
	docker build -f $(CWD)/experiments/docker/build.godepq.Dockerfile \
	             -t go-godepq-experiments-build-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$$(docker images | grep '^golang\s\+alpine' | awk '{print $$3}') \
	             $(CWD)/experiments

.PHONY: clean-godepq-artifacts
clean-godepq-artifacts:
	rm -rf $(CWD)/experiments/artifacts/godepq &>/dev/null || true

.PHONY: clean-godepq-build-image
clean-godepq-build-image:
	docker rmi -f go-godepq-experiments-build-image &>/dev/null || true

.PHONY: drop-godepq
drop-godepq: clean-invalid-experiments
drop-godepq:
	docker images --all \
	| grep '^kamilsk\/go-experiments\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep 'godepq' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: get-godepq-artifacts
get-godepq-artifacts: clean-godepq-artifacts
get-godepq-artifacts:
	docker rm -f go-godepq-experiments-container &>/dev/null || true
	mkdir -p $(CWD)/experiments/artifacts
	docker create --name go-godepq-experiments-container go-godepq-experiments-build-image
	docker cp go-godepq-experiments-container:/tmp/godepq    $(CWD)/experiments/artifacts/
	docker cp go-godepq-experiments-container:/tmp/meta.data $(CWD)/experiments/artifacts/
	cat $(CWD)/experiments/artifacts/meta.data | sed '/START METADATA/d' | sed '/END METADATA/d' | sed 's/[ ]*$$//' \
	  > $(CWD)/experiments/godepq.log
	docker rm -f go-godepq-experiments-container

.PHONY: in-godepq
in-godepq:
	docker run --rm -it kamilsk/go-experiments:godepq

.PHONY: in-godepq-image
in-godepq-image:
	docker run --rm -it go-godepq-experiments-build-image

.PHONY: pack-godepq
pack-godepq: drop-godepq
pack-godepq:
	docker build -f $(CWD)/experiments/docker/pack.godepq.Dockerfile \
	             -t kamilsk/go-experiments:godepq \
	             --force-rm --no-cache --pull --rm \
	             $(CWD)/experiments

.PHONY: publish-godepq
publish-godepq:
	docker push kamilsk/go-experiments:godepq

.PHONY: pull-godepq
pull-godepq:
	docker pull kamilsk/go-experiments:godepq
