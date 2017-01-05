#
# Go package's targets for benchmarking.
#
# Version: 1.0
#

.PHONY: bench
bench:
	go list ./... | grep -v /vendor/ | xargs go test -bench=. $(strip $(ARGS)) "$$1"
