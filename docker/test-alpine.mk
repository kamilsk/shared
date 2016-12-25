.PHONY: docker-test-1.5-alpine
docker-test-1.5-alpine:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.5-alpine \
	           go get -d -t `go list ./... | grep -v /vendor/` && \
	           go test `go list ./... | grep -v /vendor/` -v

.PHONY: docker-test-1.6-alpine
docker-test-1.6-alpine:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.6-alpine \
	           go get -d -t `go list ./... | grep -v /vendor/` && \
	           go test `go list ./... | grep -v /vendor/` -v

.PHONY: docker-test-1.7-alpine
docker-test-1.7-alpine:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.7-alpine \
	           go get -d -t `go list ./... | grep -v /vendor/` && \
	           go test `go list ./... | grep -v /vendor/` -v

.PHONY: docker-test-alpine
docker-test-alpine:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:alpine \
	           go get -d -t `go list ./... | grep -v /vendor/` && \
	           go test `go list ./... | grep -v /vendor/` -v
