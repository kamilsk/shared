#
# Go package's targets for testing.
#
# Version: 1.0
#

GO_TEST_COVERAGE_MODE     ?= count
GO_TEST_COVERAGE_FILENAME ?= coverage.out

.PHONY: test
test:
	go test -race -v ./...

.PHONY: test-with-coverage
test-with-coverage:
	go test -cover -race ./...

.PHONY: test-with-coverage-formatted
test-with-coverage-formatted:
	go test -cover -race ./... | column -t | sort -r

.PHONY: test-with-coverage-profile
test-with-coverage-profile:
	echo "mode: ${GO_TEST_COVERAGE_MODE}" > "${GO_TEST_COVERAGE_FILENAME}"
	for package in $$(go list ./...); do \
	    go test -covermode "${GO_TEST_COVERAGE_MODE}" -coverprofile "coverage_$${package##*/}.out" "$${package}"; \
	    sed '1d' "coverage_$${package##*/}.out" >> "${GO_TEST_COVERAGE_FILENAME}"; \
	done
