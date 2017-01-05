define docker_pull_alpine_gcc_tpl

.PHONY: docker-pull-$(1)-alpine-gcc
docker-pull-$(1)-alpine-gcc:
	docker pull kamilsk/golang:$(1)-alpine

endef

$(foreach v,$(SUPPORTED_VERSIONS),$(eval $(call docker_pull_alpine_gcc_tpl,$(v))))
# TODO latest-alpine -> alpine
