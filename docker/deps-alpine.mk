.PHONY: docker-deps-1.5-alpine
docker-deps-1.5-alpine:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.5-alpine \
	           go get -d -t ./...

.PHONY: docker-deps-1.6-alpine
docker-deps-1.6-alpine:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.6-alpine \
	           go get -d -t ./...

.PHONY: docker-deps-1.7-alpine
docker-deps-1.7-alpine:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.7-alpine \
	           go get -d -t ./...

.PHONY: docker-deps-alpine
docker-deps-alpine:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:alpine \
	           go get -d -t ./...
