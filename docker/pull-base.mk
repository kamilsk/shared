define docker_pull_tpl

.PHONY: docker-pull-$(1)
docker-pull-$(1):
	docker pull golang:$(1)

endef

$(foreach v,$(SUPPORTED_VERSIONS),$(eval $(call docker_pull_tpl,$(v))))
