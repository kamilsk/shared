include $(CWD)/tools/latest.mk
include $(CWD)/tools/experimental.mk

.PHONY: clean-invalid-tools
clean-invalid-tools:
	docker images --all \
	| grep '^kamilsk\/go-tools\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep '^<none>\s\+' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: clean-tools-artifacts
clean-tools-artifacts:
	rm -rf $(CWD)/tools/artifacts &>/dev/null || true
