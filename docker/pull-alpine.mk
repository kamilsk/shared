define docker_pull_alpine_tpl

.PHONY: docker-pull-$(1)-alpine
docker-pull-$(1)-alpine:
	docker pull golang:$(1)-alpine

endef

$(foreach v,$(SUPPORTED_VERSIONS),$(eval $(call docker_pull_alpine_tpl,$(v))))
# TODO latest-alpine -> alpine
