#
# Go package's targets for benchmarking.
#
# Version: 1.0
#

ifndef PACKAGES
$(error Please include env.mk before)
endif

.PHONY: bench
bench:
	$(PACKAGES) | xargs go test -bench=. $(strip $(ARGS)) "$$1"
