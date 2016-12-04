#
# Go package's targets for dependency loading.
#
# Version: 1.0
#

.PHONY: install-deps
install-deps:
	go get -d -t ./...

.PHONY: update-deps
update-deps:
	go get -d -t -u ./...
