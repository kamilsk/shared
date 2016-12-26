DEADLINE=10s
.PHONY: docker-tool-gometalinter
docker-tool-gometalinter:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           kamilsk/go-tools:latest \
	           /bin/sh -c "go list ./... | grep -v /vendor/ | xargs -n1 go test -i "$1" && \
	                       gometalinter.v1 --vendor --deadline=$(DEADLINE) ./..."
