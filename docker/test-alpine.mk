.PHONY: docker-test-1.5-alpine
docker-test-1.5-alpine:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.5-alpine \
	           go test ./... -v

.PHONY: docker-test-1.6-alpine
docker-test-1.6-alpine:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.6-alpine \
	           go test ./... -v

.PHONY: docker-test-1.7-alpine
docker-test-1.7-alpine:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.7-alpine \
	           go test ./... -v

.PHONY: docker-test-alpine
docker-test-alpine:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:alpine \
	           go test ./... -v
