define docker_alpine_tpl

.PHONY: docker-in-$(1)
docker-in-$(1):
	docker run --rm -it \
	           -v '$${GOPATH}/src/$${GO_PACKAGE}':'/go/src/$${GO_PACKAGE}' \
	           -w '/go/src/$${GO_PACKAGE}' \
	           golang:$(1) \
	           /bin/sh

.PHONY: docker-bench-$(1)
docker-bench-$(1):
	docker run --rm \
	           -v '$${GOPATH}/src/$${GO_PACKAGE}':'/go/src/$${GO_PACKAGE}' \
	           -w '/go/src/$${GO_PACKAGE}' \
	           golang:$(1) \
	           /bin/sh -c '$$(PACKAGES) | xargs go test -bench=. $$(strip $$(ARGS))'

.PHONY: docker-pull-$(1)
docker-pull-$(1):
	docker pull golang:$(1)

.PHONY: docker-test-$(1)
docker-test-$(1):
	docker run --rm \
	           -v '$${GOPATH}/src/$${GO_PACKAGE}':'/go/src/$${GO_PACKAGE}' \
	           -w '/go/src/$${GO_PACKAGE}' \
	           golang:$(1) \
	           /bin/sh -c '$$(PACKAGES) | xargs go test $$(strip $$(ARGS))'

.PHONY: docker-test-check-$(1)
docker-test-check-$(1):
	docker run --rm \
	           -v '$${GOPATH}/src/$${GO_PACKAGE}':'/go/src/$${GO_PACKAGE}' \
	           -w '/go/src/$${GO_PACKAGE}' \
	           golang:$(1) \
	           /bin/sh -c '$$(PACKAGES) | xargs go test -run=^hack $$(strip $$(ARGS))'

endef

render_docker_alpine_tpl = $(if $(filter $(version),latest), \
    $(eval $(call docker_alpine_tpl,alpine)), \
    $(eval $(call docker_alpine_tpl,$(version)-alpine)) \
)
$(foreach version,$(SUPPORTED_VERSIONS),$(render_docker_alpine_tpl))
