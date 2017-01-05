define docker_test_alpine_tpl

.PHONY: docker-test-$(1)-alpine
docker-test-$(1)-alpine:
	docker run --rm \
	           -v '$${GOPATH}/src/$${GO_PACKAGE}':'/go/src/$${GO_PACKAGE}' \
	           -w '/go/src/$${GO_PACKAGE}' \
	           golang:$(1)-alpine \
	           /bin/sh -c '$$(PACKAGES) | xargs go test $$(strip $$(ARGS)) "$$$$1"'

endef

$(foreach v,$(SUPPORTED_VERSIONS),$(eval $(call docker_test_alpine_tpl,$(v))))
# TODO latest-alpine -> alpine
