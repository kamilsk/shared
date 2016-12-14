.PHONY: docker-bench-1.5-alpine
docker-bench-1.5-alpine:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.5-alpine \
	           go get -d -t ./... && go test ./... -bench . -benchmem

.PHONY: docker-bench-1.6-alpine
docker-bench-1.6-alpine:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.6-alpine \
	           go get -d -t ./... && go test ./... -bench . -benchmem

.PHONY: docker-bench-1.7-alpine
docker-bench-1.7-alpine:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.7-alpine \
	           go get -d -t ./... && go test ./... -bench . -benchmem

.PHONY: docker-bench-alpine
docker-bench-alpine:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:alpine \
	           go get -d -t ./... && go test ./... -bench . -benchmem
