PRUNE_AVAILABLE := $(shell echo "1.13.0\n$(DOCKER_VERSION)" | sort -ct. -k1,1n -k2,2n && echo true)

PRUNE ?=

.PHONY: docker-clean
docker-clean:
	docker images --all \
	| grep '^<none>\s\+' \
	| awk '{print $$3}' \
	| xargs docker rmi -f &>/dev/null || true

	docker images --all \
	| grep '^golang\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep '^<none>\s\+' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

	docker images --all \
	| grep '^kamilsk\/golang\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep '^<none>\s\+' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

	if [ '${PRUNE}' != '' ] && [ '${PRUNE_AVAILABLE}' == 'true' ]; then docker system prune $(strip $(PRUNE)); fi
