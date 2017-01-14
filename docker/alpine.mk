define docker_alpine_tpl

.PHONY: docker-bench-$(1)-alpine
docker-bench-$(1)-alpine:
	docker run --rm \
	           -v '$${GOPATH}/src/$${GO_PACKAGE}':'/go/src/$${GO_PACKAGE}' \
	           -w '/go/src/$${GO_PACKAGE}' \
	           golang:$(1)-alpine \
	           /bin/sh -c '$$(PACKAGES) | xargs go test -bench=. $$(strip $$(ARGS))'

.PHONY: docker-pull-$(1)-alpine
docker-pull-$(1)-alpine:
	docker pull golang:$(1)-alpine

.PHONY: docker-test-$(1)-alpine
docker-test-$(1)-alpine:
	docker run --rm \
	           -v '$${GOPATH}/src/$${GO_PACKAGE}':'/go/src/$${GO_PACKAGE}' \
	           -w '/go/src/$${GO_PACKAGE}' \
	           golang:$(1)-alpine \
	           /bin/sh -c '$$(PACKAGES) | xargs go test $$(strip $$(ARGS))'

endef
$(foreach v,$(SUPPORTED_VERSIONS),$(eval $(call docker_alpine_tpl,$(v))))
# TODO latest-alpine -> alpine
