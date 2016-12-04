#
# Go package's targets for tooling.
#
# Version: 1.0
#

.PHONY: build
build:
	go build -v ./...

.PHONY: clean
clean:
	go clean -i -x ./...

.PHONY: install
install:
	go install ./...

.PHONY: vet
vet:
	go vet ./...
