#
# Go package's docker environment.
#
# Version: 1.0
#

ifndef GO_PACKAGE
$(error Please provide GO_PACKAGE (e.g. GO_PACKAGE:="github.com/kamilsk/semaphore"))
endif

#
# Benchmarking
#

# - on base images

.PHONY: docker-bench-1.5
docker-bench-1.5:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.5 \
	           go test ./... -bench . -benchmem

.PHONY: docker-bench-1.6
docker-bench-1.6:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.6 \
	           go test ./... -bench . -benchmem

.PHONY: docker-bench-1.7
docker-bench-1.7:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.7 \
	           go test ./... -bench . -benchmem

.PHONY: docker-bench
docker-bench:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:latest \
	           go test ./... -bench . -benchmem

# - on alpine images

.PHONY: docker-bench-1.5-alpine
docker-bench-1.5-alpine:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.5-alpine \
	           go test ./... -bench . -benchmem

.PHONY: docker-bench-1.6-alpine
docker-bench-1.6-alpine:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.6-alpine \
	           go test ./... -bench . -benchmem

.PHONY: docker-bench-1.7-alpine
docker-bench-1.7-alpine:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.7-alpine \
	           go test ./... -bench . -benchmem

.PHONY: docker-bench-alpine
docker-bench-alpine:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:alpine \
	           go test ./... -bench . -benchmem

# - on alpine-gcc images

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

#
# Testing
#

# - on base images

.PHONY: docker-test-1.5
docker-test-1.5:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.5 \
	           go test ./... -v

.PHONY: docker-test-1.6
docker-test-1.6:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.6 \
	           go test ./... -v

.PHONY: docker-test-1.7
docker-test-1.7:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.7 \
	           go test ./... -v

.PHONY: docker-test
docker-test:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:latest \
	           go test ./... -v

# - on alpine images

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

# - on alpine-gcc images

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
