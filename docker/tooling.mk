DEADLINE=10s
.PHONY: docker-tool-gometalinter
docker-tool-gometalinter:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           kamilsk/go-tools:latest \
	           gometalinter.v1 --vendor --deadline=$(DEADLINE) ./...
