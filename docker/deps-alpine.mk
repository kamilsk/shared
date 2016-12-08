.PHONY: docker-install-deps-1.5-alpine
docker-install-deps-1.5-alpine:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.5-alpine \
	           go get -d -t ./...

.PHONY: docker-install-deps-1.6-alpine
docker-install-deps-1.6-alpine:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.6-alpine \
	           go get -d -t ./...

.PHONY: docker-install-deps-1.7-alpine
docker-install-deps-1.7-alpine:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.7-alpine \
	           go get -d -t ./...

.PHONY: docker-install-deps-alpine
docker-install-deps-alpine:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:alpine \
	           go get -d -t ./...

.PHONY: docker-update-deps-1.5-alpine
docker-update-deps-1.5-alpine:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.5-alpine \
	           go get -d -t -u ./...

.PHONY: docker-update-deps-1.6-alpine
docker-update-deps-1.6-alpine:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.6-alpine \
	           go get -d -t -u ./...

.PHONY: docker-update-deps-1.7-alpine
docker-update-deps-1.7-alpine:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.7-alpine \
	           go get -d -t -u ./...

.PHONY: docker-update-deps-alpine
docker-update-deps-alpine:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:alpine \
	           go get -d -t -u ./...
