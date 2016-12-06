.PHONY: docker-deps-1.5
docker-deps-1.5:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.5 \
	           go get -d -t ./...

.PHONY: docker-deps-1.6
docker-deps-1.6:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.6 \
	           go get -d -t ./...

.PHONY: docker-deps-1.7
docker-deps-1.7:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.7 \
	           go get -d -t ./...

.PHONY: docker-deps
docker-deps:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:latest \
	           go get -d -t ./...
