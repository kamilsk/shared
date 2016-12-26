.PHONY: docker-test-1.5-alpine-gcc
docker-test-1.5-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           kamilsk/golang:1.5-alpine \
	           /bin/sh -c "go list ./... | grep -v /vendor/ | xargs -n1 go get -d -t "$1" && \
	                       go list ./... | grep -v /vendor/ | xargs -n1 go test -v "$1""

.PHONY: docker-test-1.6-alpine-gcc
docker-test-1.6-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           kamilsk/golang:1.6-alpine \
	           /bin/sh -c "go list ./... | grep -v /vendor/ | xargs -n1 go get -d -t "$1" && \
	                       go list ./... | grep -v /vendor/ | xargs -n1 go test -v "$1""

.PHONY: docker-test-1.7-alpine-gcc
docker-test-1.7-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           kamilsk/golang:1.7-alpine \
	           /bin/sh -c "go list ./... | grep -v /vendor/ | xargs -n1 go get -d -t "$1" && \
	                       go list ./... | grep -v /vendor/ | xargs -n1 go test -v "$1""

.PHONY: docker-test-alpine-gcc
docker-test-alpine-gcc:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           kamilsk/golang:alpine \
	           /bin/sh -c "go list ./... | grep -v /vendor/ | xargs -n1 go get -d -t "$1" && \
	                       go list ./... | grep -v /vendor/ | xargs -n1 go test -v "$1""
