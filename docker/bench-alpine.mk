define docker_bench_alpine_tpl

.PHONY: docker-bench-$(1)-alpine
docker-bench-$(1)-alpine:
	docker run --rm \
	           -v '$${GOPATH}/src/$${GO_PACKAGE}':'/go/src/$${GO_PACKAGE}' \
	           -w '/go/src/$${GO_PACKAGE}' \
	           golang:$(1)-alpine \
	           /bin/sh -c '$$(PACKAGES) | xargs go test -bench=. $$(strip $$(ARGS)) "$$$$1"'

endef

$(foreach v,$(SUPPORTED_VERSIONS),$(eval $(call docker_bench_alpine_tpl,$(v))))
# TODO latest-alpine -> alpine
