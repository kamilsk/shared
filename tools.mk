#
# Go package's targets for tooling.
#
# Version: 1.0
#

.PHONY: build
build:
	go list ./... | grep -v /vendor/ | xargs go build -v "$1"

.PHONY: clean
clean:
	go list ./... | grep -v /vendor/ | xargs go clean -i -x "$1"

.PHONY: install
install:
	go list ./... | grep -v /vendor/ | xargs go install "$1"

.PHONY: vet
vet:
	go list ./... | grep -v /vendor/ | xargs go vet "$1"
