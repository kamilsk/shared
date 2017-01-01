#
# Go package's targets for testing.
#
# Version: 1.0
#

ARGS         =
OPEN_BROWSER =

GO_TEST_COVERAGE_MODE     ?= count
GO_TEST_COVERAGE_FILENAME ?= coverage.out

.PHONY: test
test:
	go list ./... | grep -v /vendor/ | xargs go test -race $(strip $(ARGS)) "$1"

.PHONY: test-with-coverage
test-with-coverage:
	go list ./... | grep -v /vendor/ | xargs go test -cover $(strip $(ARGS)) "$1"

.PHONY: test-with-coverage-formatted
test-with-coverage-formatted:
	go list ./... | grep -v /vendor/ | xargs go test -cover $(strip $(ARGS)) "$1" | column -t | sort -r

.PHONY: test-with-coverage-profile
test-with-coverage-profile:
	echo "mode: ${GO_TEST_COVERAGE_MODE}" > "${GO_TEST_COVERAGE_FILENAME}"
	for package in $$(go list ./...); do \
	    go test -covermode "${GO_TEST_COVERAGE_MODE}" \
	            -coverprofile "coverage_$${package##*/}.out" \
	            $(strip $(ARGS)) "$${package}"; \
	    sed '1d' "coverage_$${package##*/}.out" >> "${GO_TEST_COVERAGE_FILENAME}"; \
	    rm "coverage_$${package##*/}.out"; \
	done
	if [ "$(OPEN_BROWSER)" != "" ]; then go tool cover -html="${GO_TEST_COVERAGE_FILENAME}"; fi
