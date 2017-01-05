define docker_bench_alpine_gcc_tpl

.PHONY: docker-bench-$(1)-alpine-gcc
docker-bench-$(1)-alpine-gcc:
	docker run --rm \
	           -v '$${GOPATH}/src/$${GO_PACKAGE}':'/go/src/$${GO_PACKAGE}' \
	           -w '/go/src/$${GO_PACKAGE}' \
	           kamilsk/golang:$(1)-alpine \
	           /bin/sh -c '$$(PACKAGES) | xargs go get -d -t "$$$$1" && \
	                       $$(PACKAGES) | xargs go test -bench=. $$(strip $$(ARGS)) "$$$$1"'

endef

$(foreach v,$(SUPPORTED_VERSIONS),$(eval $(call docker_bench_alpine_gcc_tpl,$(v))))
# TODO latest-alpine -> alpine
