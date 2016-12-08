.PHONY: docker-install-deps-1.5-alpine-gcc
docker-install-deps-1.5-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           kamilsk/golang:1.5-alpine \
	           go get -d -t ./...

.PHONY: docker-install-deps-1.6-alpine-gcc
docker-install-deps-1.6-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           kamilsk/golang:1.6-alpine \
	           go get -d -t ./...

.PHONY: docker-install-deps-1.7-alpine-gcc
docker-install-deps-1.7-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           kamilsk/golang:1.7-alpine \
	           go get -d -t ./...

.PHONY: docker-install-deps-alpine-gcc
docker-install-deps-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           kamilsk/golang:alpine \
	           go get -d -t ./...

.PHONY: docker-update-deps-1.5-alpine-gcc
docker-update-deps-1.5-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           kamilsk/golang:1.5-alpine \
	           go get -d -t -u ./...

.PHONY: docker-update-deps-1.6-alpine-gcc
docker-update-deps-1.6-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           kamilsk/golang:1.6-alpine \
	           go get -d -t -u ./...

.PHONY: docker-update-deps-1.7-alpine-gcc
docker-update-deps-1.7-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           kamilsk/golang:1.7-alpine \
	           go get -d -t -u ./...

.PHONY: docker-update-deps-alpine-gcc
docker-update-deps-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           kamilsk/golang:alpine \
	           go get -d -t -u ./...
