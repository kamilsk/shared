.PHONY: docker-deps-1.5-alpine-gcc
docker-deps-1.5-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           kamilsk/golang:1.5-alpine \
	           go get -d -t ./...

.PHONY: docker-deps-1.6-alpine-gcc
docker-deps-1.6-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           kamilsk/golang:1.6-alpine \
	           go get -d -t ./...

.PHONY: docker-deps-1.7-alpine-gcc
docker-deps-1.7-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           kamilsk/golang:1.7-alpine \
	           go get -d -t ./...

.PHONY: docker-deps-alpine-gcc
docker-deps-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           kamilsk/golang:alpine \
	           go get -d -t ./...
