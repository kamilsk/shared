.PHONY: docker-bench-1.5-alpine-gcc
docker-bench-1.5-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           kamilsk/golang:1.5-alpine \
	           go get -d -t ./... && go test ./... -bench . -benchmem

.PHONY: docker-bench-1.6-alpine-gcc
docker-bench-1.6-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           kamilsk/golang:1.6-alpine \
	           go get -d -t ./... && go test ./... -bench . -benchmem

.PHONY: docker-bench-1.7-alpine-gcc
docker-bench-1.7-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           kamilsk/golang:1.7-alpine \
	           go get -d -t ./... && go test ./... -bench . -benchmem

.PHONY: docker-bench-alpine-gcc
docker-bench-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           kamilsk/golang:alpine \
	           go get -d -t ./... && go test ./... -bench . -benchmem
