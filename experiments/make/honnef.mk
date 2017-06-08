.PHONY: build-honnef
build-honnef: build-honnef-image
build-honnef: get-honnef-artifacts
build-honnef: pack-honnef
build-honnef:
	make clean-honnef-artifacts
	make clean-honnef-build-image

.PHONY: build-honnef-image
build-honnef-image: clean-honnef-build-image
build-honnef-image:
	docker build -f $(CWD)/experiments/docker/build.honnef.Dockerfile \
	             -t go-honnef-experiments-build-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$$(docker images | grep '^golang\s\+alpine' | awk '{print $$3}') \
	             $(CWD)/experiments

.PHONY: clean-honnef-artifacts
clean-honnef-artifacts:
	rm -rf $(CWD)/experiments/artifacts/honnef &>/dev/null || true

.PHONY: clean-honnef-build-image
clean-honnef-build-image:
	docker rmi -f go-honnef-experiments-build-image &>/dev/null || true

.PHONY: drop-honnef
drop-honnef: clean-invalid-experiments
drop-honnef:
	docker images --all \
	| grep '^kamilsk\/go-experiments\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep 'honnef' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: get-honnef-artifacts
get-honnef-artifacts: clean-honnef-artifacts
get-honnef-artifacts:
	docker rm -f go-honnef-experiments-container &>/dev/null || true
	mkdir -p $(CWD)/experiments/artifacts
	docker create --name go-honnef-experiments-container go-honnef-experiments-build-image
	docker cp go-honnef-experiments-container:/tmp/honnef    $(CWD)/experiments/artifacts/
	docker cp go-honnef-experiments-container:/tmp/meta.data $(CWD)/experiments/artifacts/
	cat $(CWD)/experiments/artifacts/meta.data | sed '/START METADATA/d' | sed '/END METADATA/d' | sed 's/[ ]*$$//' \
	  > $(CWD)/experiments/honnef.log
	docker rm -f go-honnef-experiments-container

.PHONY: in-honnef
in-honnef:
	docker run --rm -it kamilsk/go-experiments:honnef

.PHONY: in-honnef-image
in-honnef-image:
	docker run --rm -it go-honnef-experiments-build-image

.PHONY: pack-honnef
pack-honnef: drop-honnef
pack-honnef:
	docker build -f $(CWD)/experiments/docker/pack.honnef.Dockerfile \
	             -t kamilsk/go-experiments:honnef \
	             --force-rm --no-cache --pull --rm \
	             $(CWD)/experiments

.PHONY: publish-honnef
publish-honnef:
	docker push kamilsk/go-experiments:honnef

.PHONY: pull-honnef
pull-honnef:
	docker pull kamilsk/go-experiments:honnef
