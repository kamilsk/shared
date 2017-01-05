define docker_bench_tpl

.PHONY: docker-bench-$(1)
docker-bench-$(1):
	docker run --rm \
	           -v '$${GOPATH}/src/$${GO_PACKAGE}':'/go/src/$${GO_PACKAGE}' \
	           -w '/go/src/$${GO_PACKAGE}' \
	           golang:$(1) \
	           /bin/sh -c '$$(PACKAGES) | xargs go get -d -t "$$$$1" && \
	                       $$(PACKAGES) | xargs go test -bench=. $$(strip $$(ARGS)) "$$$$1"'

endef

$(foreach v,$(SUPPORTED_VERSIONS),$(eval $(call docker_bench_tpl,$(v))))
