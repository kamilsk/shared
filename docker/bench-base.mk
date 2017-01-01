.PHONY: docker-bench-1.5
docker-bench-1.5:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.5 \
	           /bin/sh -c "go list ./... | grep -v /vendor/ | xargs go get -d -t "$1" && \
	                       go list ./... | grep -v /vendor/ | xargs go test -bench=. $(strip $(ARGS)) "$1""

.PHONY: docker-bench-1.6
docker-bench-1.6:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.6 \
	           /bin/sh -c "go list ./... | grep -v /vendor/ | xargs go get -d -t "$1" && \
	                       go list ./... | grep -v /vendor/ | xargs go test -bench=. $(strip $(ARGS)) "$1""

.PHONY: docker-bench-1.7
docker-bench-1.7:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.7 \
	           /bin/sh -c "go list ./... | grep -v /vendor/ | xargs go get -d -t "$1" && \
	                       go list ./... | grep -v /vendor/ | xargs go test -bench=. $(strip $(ARGS)) "$1""

.PHONY: docker-bench-latest
docker-bench-latest:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:latest \
	           /bin/sh -c "go list ./... | grep -v /vendor/ | xargs go get -d -t "$1" && \
	                       go list ./... | grep -v /vendor/ | xargs go test -bench=. $(strip $(ARGS)) "$1""
