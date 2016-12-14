.PHONY: docker-bench-1.5
docker-bench-1.5:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.5 \
	           go get -d -t ./... && go test ./... -bench . -benchmem

.PHONY: docker-bench-1.6
docker-bench-1.6:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.6 \
	           go get -d -t ./... && go test ./... -bench . -benchmem

.PHONY: docker-bench-1.7
docker-bench-1.7:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.7 \
	           go get -d -t ./... && go test ./... -bench . -benchmem

.PHONY: docker-bench-latest
docker-bench-latest:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:latest \
	           go get -d -t ./... && go test ./... -bench . -benchmem
