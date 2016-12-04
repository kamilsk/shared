#
# Go package's targets for tooling.
#
# Version: 1.0
#

clean:
	go clean -i -x ./...

vet:
	go vet ./...
