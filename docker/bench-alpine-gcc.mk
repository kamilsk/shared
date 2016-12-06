.PHONY: docker-bench-1.5-alpine-gcc
docker-bench-1.5-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           kamilsk/golang:1.5-alpine \
	           go test ./... -bench . -benchmem

.PHONY: docker-bench-1.6-alpine-gcc
docker-bench-1.6-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           kamilsk/golang:1.6-alpine \
	           go test ./... -bench . -benchmem

.PHONY: docker-bench-1.7-alpine-gcc
docker-bench-1.7-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           kamilsk/golang:1.7-alpine \
	           go test ./... -bench . -benchmem

.PHONY: docker-bench-alpine-gcc
docker-bench-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           kamilsk/golang:alpine \
	           go test ./... -bench . -benchmem
