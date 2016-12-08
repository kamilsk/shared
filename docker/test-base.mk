.PHONY: docker-test-1.5
docker-test-1.5:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.5 \
	           go test ./... -race -v

.PHONY: docker-test-1.6
docker-test-1.6:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.6 \
	           go test ./... -race -v

.PHONY: docker-test-1.7
docker-test-1.7:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.7 \
	           go test ./... -race -v

.PHONY: docker-test-latest
docker-test-latest:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:latest \
	           go test ./... -race -v
