#
# Go package's targets for dependency loading.
#
# Version: 1.0
#

ifndef PACKAGES
$(error Please include env.mk before)
endif

.PHONY: install-deps
install-deps:
	$(PACKAGES) | xargs go get -d -t "$$1"

.PHONY: update-deps
update-deps:
	$(PACKAGES) | xargs go get -d -t -u "$$1"
