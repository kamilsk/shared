.PHONY: build-apicompat
build-apicompat: build-apicompat-image
build-apicompat: get-apicompat-artifacts
build-apicompat: pack-apicompat
build-apicompat:
	make clean-apicompat-artifacts
	make clean-apicompat-build-image

.PHONY: build-apicompat-image
build-apicompat-image: clean-apicompat-build-image
build-apicompat-image:
	docker build -f $(CWD)/experiments/docker/build.apicompat.Dockerfile \
	             -t go-apicompat-experiments-build-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$$(docker images | grep '^golang\s\+alpine' | awk '{print $$3}') \
	             $(CWD)/experiments

.PHONY: clean-apicompat-artifacts
clean-apicompat-artifacts:
	rm -rf $(CWD)/experiments/artifacts/apicompat &>/dev/null || true

.PHONY: clean-apicompat-build-image
clean-apicompat-build-image:
	docker rmi -f go-apicompat-experiments-build-image &>/dev/null || true

.PHONY: drop-apicompat
drop-apicompat: clean-invalid-experiments
drop-apicompat:
	docker images --all \
	| grep '^kamilsk\/go-experiments\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep 'apicompat' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: get-apicompat-artifacts
get-apicompat-artifacts: clean-apicompat-artifacts
get-apicompat-artifacts:
	docker rm -f go-apicompat-experiments-container &>/dev/null || true
	mkdir -p $(CWD)/experiments/artifacts
	docker create --name go-apicompat-experiments-container go-apicompat-experiments-build-image
	docker cp go-apicompat-experiments-container:/tmp/apicompat  $(CWD)/experiments/artifacts/
	docker cp go-apicompat-experiments-container:/tmp/meta.data  $(CWD)/experiments/artifacts/
	cat $(CWD)/experiments/artifacts/meta.data | sed '/START METADATA/d' | sed '/END METADATA/d' | sed 's/[ ]*$$//' \
	  > $(CWD)/experiments/apicompat.log
	docker rm -f go-apicompat-experiments-container

.PHONY: in-apicompat
in-apicompat:
	docker run --rm -it kamilsk/go-experiments:apicompat

.PHONY: in-apicompat-image
in-apicompat-image:
	docker run --rm -it go-apicompat-experiments-build-image

.PHONY: pack-apicompat
pack-apicompat: drop-apicompat
pack-apicompat:
	docker build -f $(CWD)/experiments/docker/pack.apicompat.Dockerfile \
	             -t kamilsk/go-experiments:apicompat \
	             --force-rm --no-cache --pull --rm \
	             $(CWD)/experiments

.PHONY: publish-apicompat
publish-apicompat:
	docker push kamilsk/go-experiments:apicompat

.PHONY: pull-apicompat
pull-apicompat:
	docker pull kamilsk/go-experiments:apicompat
