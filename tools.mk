#
# Go package's targets for tooling.
#
# Version: 1.0
#

ifndef PACKAGES
$(error Please include env.mk before)
endif

.PHONY: build
build:
	$(PACKAGES) | xargs go build -v "$$1"

.PHONY: clean
clean:
	$(PACKAGES) | xargs go clean -i -x "$$1"

.PHONY: install
install:
	$(PACKAGES) | xargs go install "$$1"

.PHONY: vet
vet:
	$(PACKAGES) | xargs go vet "$$1"
