include $(CWD)/experiments/proto.mk
include $(CWD)/experiments/ponzu.mk
include $(CWD)/experiments/goreporter.mk

.PHONY: clean-invalid-experiments
clean-invalid-experiments:
	docker images --all \
	| grep '^kamilsk\/go-experiments\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep '^<none>\s\+' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: clean-experiments-artifacts
clean-experiments-artifacts:
	rm -rf $(CWD)/experiments/artifacts &>/dev/null || true
