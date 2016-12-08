.PHONY: docker-install-deps-1.5
docker-install-deps-1.5:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.5 \
	           go get -d -t ./...

.PHONY: docker-install-deps-1.6
docker-install-deps-1.6:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.6 \
	           go get -d -t ./...

.PHONY: docker-install-deps-1.7
docker-install-deps-1.7:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.7 \
	           go get -d -t ./...

.PHONY: docker-install-deps-latest
docker-install-deps-latest:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:latest \
	           go get -d -t ./...

.PHONY: docker-update-deps-1.5
docker-update-deps-1.5:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.5 \
	           go get -d -t -u ./...

.PHONY: docker-update-deps-1.6
docker-update-deps-1.6:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.6 \
	           go get -d -t -u ./...

.PHONY: docker-update-deps-1.7
docker-update-deps-1.7:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:1.7 \
	           go get -d -t -u ./...

.PHONY: docker-update-deps-latest
docker-update-deps-latest:
	docker run --rm \
	           -v "${GOPATH}":/go \
	           -w /go/src/${GO_PACKAGE} \
	           golang:latest \
	           go get -d -t -u ./...
