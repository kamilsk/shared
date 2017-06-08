.PHONY: build-zb
build-zb: build-zb-image
build-zb: get-zb-artifacts
build-zb: pack-zb
build-zb:
	make clean-zb-artifacts
	make clean-zb-build-image

.PHONY: build-zb-image
build-zb-image: clean-zb-build-image
build-zb-image:
	docker build -f $(CWD)/experiments/docker/build.zb.Dockerfile \
	             -t go-zb-experiments-build-image \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$$(docker images | grep '^golang\s\+alpine' | awk '{print $$3}') \
	             $(CWD)/experiments

.PHONY: clean-zb-artifacts
clean-zb-artifacts:
	rm -rf $(CWD)/experiments/artifacts/zb &>/dev/null || true

.PHONY: clean-zb-build-image
clean-zb-build-image:
	docker rmi -f go-zb-experiments-build-image &>/dev/null || true

.PHONY: drop-zb
drop-zb: clean-invalid-experiments
drop-zb:
	docker images --all \
	| grep '^kamilsk\/go-experiments\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep 'zb' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: get-zb-artifacts
get-zb-artifacts: clean-zb-artifacts
get-zb-artifacts:
	docker rm -f go-zb-experiments-container &>/dev/null || true
	mkdir -p $(CWD)/experiments/artifacts
	docker create --name go-zb-experiments-container go-zb-experiments-build-image
	docker cp go-zb-experiments-container:/tmp/zb    $(CWD)/experiments/artifacts/
	docker cp go-zb-experiments-container:/tmp/meta.data $(CWD)/experiments/artifacts/
	cat $(CWD)/experiments/artifacts/meta.data | sed '/START METADATA/d' | sed '/END METADATA/d' | sed 's/[ ]*$$//' \
	  > $(CWD)/experiments/zb.log
	docker rm -f go-zb-experiments-container

.PHONY: in-zb
in-zb:
	docker run --rm -it kamilsk/go-experiments:zb

.PHONY: in-zb-image
in-zb-image:
	docker run --rm -it go-zb-experiments-build-image

.PHONY: pack-zb
pack-zb: drop-zb
pack-zb:
	docker build -f $(CWD)/experiments/docker/pack.zb.Dockerfile \
	             -t kamilsk/go-experiments:zb \
	             --force-rm --no-cache --pull --rm \
	             $(CWD)/experiments

.PHONY: publish-zb
publish-zb:
	docker push kamilsk/go-experiments:zb

.PHONY: pull-zb
pull-zb:
	docker pull kamilsk/go-experiments:zb
