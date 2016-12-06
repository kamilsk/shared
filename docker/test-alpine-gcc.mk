.PHONY: docker-test-1.5-alpine-gcc
docker-test-1.5-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           kamilsk/golang:1.5-alpine \
	           go test ./... -v

.PHONY: docker-test-1.6-alpine-gcc
docker-test-1.6-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           kamilsk/golang:1.6-alpine \
	           go test ./... -v

.PHONY: docker-test-1.7-alpine-gcc
docker-test-1.7-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           kamilsk/golang:1.7-alpine \
	           go test ./... -v

.PHONY: docker-test-alpine-gcc
docker-test-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           kamilsk/golang:alpine \
	           go test ./... -v
