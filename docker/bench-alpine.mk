.PHONY: docker-bench-1.5-alpine
docker-bench-1.5-alpine:
	docker run --rm \
	           -v '${GOPATH}/src/${GO_PACKAGE}':'/go/src/${GO_PACKAGE}' \
	           -w '/go/src/${GO_PACKAGE}' \
	           golang:1.5-alpine \
	           /bin/sh -c 'go list ./... | grep -v /vendor/ | xargs go test -bench=. $(strip $(ARGS)) "$$1"'

.PHONY: docker-bench-1.6-alpine
docker-bench-1.6-alpine:
	docker run --rm \
	           -v '${GOPATH}/src/${GO_PACKAGE}':'/go/src/${GO_PACKAGE}' \
	           -w '/go/src/${GO_PACKAGE}' \
	           golang:1.6-alpine \
	           /bin/sh -c 'go list ./... | grep -v /vendor/ | xargs go test -bench=. $(strip $(ARGS)) "$$1"'

.PHONY: docker-bench-1.7-alpine
docker-bench-1.7-alpine:
	docker run --rm \
	           -v '${GOPATH}/src/${GO_PACKAGE}':'/go/src/${GO_PACKAGE}' \
	           -w '/go/src/${GO_PACKAGE}' \
	           golang:1.7-alpine \
	           /bin/sh -c 'go list ./... | grep -v /vendor/ | xargs go test -bench=. $(strip $(ARGS)) "$$1"'

.PHONY: docker-bench-alpine
docker-bench-alpine:
	docker run --rm \
	           -v '${GOPATH}/src/${GO_PACKAGE}':'/go/src/${GO_PACKAGE}' \
	           -w '/go/src/${GO_PACKAGE}' \
	           golang:alpine \
	           /bin/sh -c 'go list ./... | grep -v /vendor/ | xargs go test -bench=. $(strip $(ARGS)) "$$1"'
