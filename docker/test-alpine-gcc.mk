.PHONY: docker-test-1.5-alpine-gcc
docker-test-1.5-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           kamilsk/golang:1.5-alpine \
	           /bin/sh -c "go get -d -t `go list ./... | grep -v /vendor/` && \
	                       go test `go list ./... | grep -v /vendor/` -v"

.PHONY: docker-test-1.6-alpine-gcc
docker-test-1.6-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           kamilsk/golang:1.6-alpine \
	           /bin/sh -c "go get -d -t `go list ./... | grep -v /vendor/` && \
	                       go test `go list ./... | grep -v /vendor/` -v"

.PHONY: docker-test-1.7-alpine-gcc
docker-test-1.7-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           kamilsk/golang:1.7-alpine \
	           /bin/sh -c "go get -d -t `go list ./... | grep -v /vendor/` && \
	                       go test `go list ./... | grep -v /vendor/` -v"

.PHONY: docker-test-alpine-gcc
docker-test-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           kamilsk/golang:alpine \
	           /bin/sh -c "go get -d -t `go list ./... | grep -v /vendor/` && \
	                       go test `go list ./... | grep -v /vendor/` -v"
