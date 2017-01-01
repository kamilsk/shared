#
# Go package's targets for dependency loading.
#
# Version: 1.0
#

.PHONY: install-deps
install-deps:
	go list ./... | grep -v /vendor/ | xargs go get -d -t "$1"

.PHONY: update-deps
update-deps:
	go list ./... | grep -v /vendor/ | xargs go get -d -t -u "$1"
