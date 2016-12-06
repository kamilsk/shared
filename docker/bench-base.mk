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

.PHONY: docker-bench-latest
docker-bench-latest:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:latest \
	           go test ./... -bench . -benchmem
