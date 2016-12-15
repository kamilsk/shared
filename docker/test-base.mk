# with verbose and race

.PHONY: docker-test-1.5
docker-test-1.5:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.5 \
	           go get -d -t ./... && go test ./... -race -v

.PHONY: docker-test-1.6
docker-test-1.6:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.6 \
	           go get -d -t ./... && go test ./... -race -v

.PHONY: docker-test-1.7
docker-test-1.7:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.7 \
	           go get -d -t ./... && go test ./... -race -v

.PHONY: docker-test-latest
docker-test-latest:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:latest \
	           go get -d -t ./... && go test ./... -race -v

# with coverage

.PHONY: docker-test-1.5-with-coverage
docker-test-1.5-with-coverage:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.5 \
	           go get -d -t ./... && \
	           echo "mode: count" > "coverage-$@.out" && \
	           for package in $$(go list ./...); do \
	               go test -cover -covermode count -coverprofile "coverage-$@-$${package##*/}.out" "$${package}"; \
	               sed '1d' "coverage-$@-$${package##*/}.out" >> "coverage-$@.out"; \
	           done
	if [ "${OPEN_BROWSER}" != "" ]; then go tool cover -html="coverage-$@.out"; fi

.PHONY: docker-test-1.6-with-coverage
docker-test-1.6-with-coverage:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.6 \
	           go get -d -t ./... && \
	           echo "mode: count" > "coverage-$@.out" && \
	           for package in $$(go list ./...); do \
	               go test -cover -covermode count -coverprofile "coverage-$@-$${package##*/}.out" "$${package}"; \
	               sed '1d' "coverage-$@-$${package##*/}.out" >> "coverage-$@.out"; \
	           done
	if [ "${OPEN_BROWSER}" != "" ]; then go tool cover -html="coverage-$@.out"; fi

.PHONY: docker-test-1.7-with-coverage
docker-test-1.7-with-coverage:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.7 \
	           go get -d -t ./... && \
	           echo "mode: count" > "coverage-$@.out" && \
	           for package in $$(go list ./...); do \
	               go test -cover -covermode count -coverprofile "coverage-$@-$${package##*/}.out" "$${package}"; \
	               sed '1d' "coverage-$@-$${package##*/}.out" >> "coverage-$@.out"; \
	           done
	if [ "${OPEN_BROWSER}" != "" ]; then go tool cover -html="coverage-$@.out"; fi

.PHONY: docker-test-latest-with-coverage
docker-test-latest-with-coverage:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:latest \
	           go get -d -t ./... && \
	           echo "mode: count" > "coverage-$@.out" && \
	           for package in $$(go list ./...); do \
	               go test -cover -covermode count -coverprofile "coverage-$@-$${package##*/}.out" "$${package}"; \
	               sed '1d' "coverage-$@-$${package##*/}.out" >> "coverage-$@.out"; \
	           done
	if [ "${OPEN_BROWSER}" != "" ]; then go tool cover -html="coverage-$@.out"; fi
