include $(CWD)/experiments/make/apicompat.mk
include $(CWD)/experiments/make/benchcmp.mk
include $(CWD)/experiments/make/depth.mk
include $(CWD)/experiments/make/godepq.mk
include $(CWD)/experiments/make/goreporter.mk
include $(CWD)/experiments/make/honnef.mk
include $(CWD)/experiments/make/maintainer.mk
include $(CWD)/experiments/make/ponzu.mk
include $(CWD)/experiments/make/zb.mk

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

.PHONY: drop-experiments
drop-experiments: drop-apicompat
drop-experiments: drop-benchcmp
drop-experiments: drop-depth
drop-experiments: drop-godepq
drop-experiments: drop-goreporter
drop-experiments: drop-honnef
drop-experiments: drop-ponzu
drop-experiments: drop-zb

.PHONY: publish-experiments
publish-experiments: publish-apicompat
publish-experiments: publish-benchcmp
publish-experiments: publish-depth
publish-experiments: publish-godepq
publish-experiments: publish-goreporter
publish-experiments: publish-honnef
publish-experiments: publish-ponzu
publish-experiments: publish-zb

.PHONY: pull-experiments
pull-experiments: pull-apicompat
pull-experiments: pull-benchcmp
pull-experiments: pull-depth
pull-experiments: pull-godepq
pull-experiments: pull-goreporter
pull-experiments: pull-honnef
pull-experiments: pull-ponzu
pull-experiments: pull-zb
