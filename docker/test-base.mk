# with verbose and race

.PHONY: docker-test-1.5
docker-test-1.5:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.5 \
	           /bin/sh -c "go list ./... | grep -v /vendor/ | xargs -n1 go get -d -t "$1" && \
	                       go list ./... | grep -v /vendor/ | xargs -n1 go test -race -v "$1""

.PHONY: docker-test-1.6
docker-test-1.6:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.6 \
	           /bin/sh -c "go list ./... | grep -v /vendor/ | xargs -n1 go get -d -t "$1" && \
	                       go list ./... | grep -v /vendor/ | xargs -n1 go test -race -v "$1""

.PHONY: docker-test-1.7
docker-test-1.7:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.7 \
	           /bin/sh -c "go list ./... | grep -v /vendor/ | xargs -n1 go get -d -t "$1" && \
	                       go list ./... | grep -v /vendor/ | xargs -n1 go test -race -v "$1""

.PHONY: docker-test-latest
docker-test-latest:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:latest \
	           /bin/sh -c "go list ./... | grep -v /vendor/ | xargs -n1 go get -d -t "$1" && \
	                       go list ./... | grep -v /vendor/ | xargs -n1 go test -race -v "$1""

# with coverage

.PHONY: docker-test-1.5-with-coverage
docker-test-1.5-with-coverage:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.5 \
	           /bin/sh -c "go list ./... | grep -v /vendor/ | xargs -n1 go get -d -t "$1" && \
	                       echo "mode: count" > "coverage-$@.out" && \
	                       for package in $$(go list ./... | grep -v /vendor/); do \
	                           go test -cover -covermode count -coverprofile "coverage-$@-$${package##*/}.out" "$${package}"; \
	                           sed '1d' "coverage-$@-$${package##*/}.out" >> "coverage-$@.out"; \
	                       done"
	if [ "${OPEN_BROWSER}" != "" ]; then go tool cover -html="coverage-$@.out"; fi

.PHONY: docker-test-1.6-with-coverage
docker-test-1.6-with-coverage:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.6 \
	           /bin/sh -c "go list ./... | grep -v /vendor/ | xargs -n1 go get -d -t "$1" && \
	                       echo "mode: count" > "coverage-$@.out" && \
	                       for package in $$(go list ./... | grep -v /vendor/); do \
	                           go test -cover -covermode count -coverprofile "coverage-$@-$${package##*/}.out" "$${package}"; \
	                           sed '1d' "coverage-$@-$${package##*/}.out" >> "coverage-$@.out"; \
	                       done"
	if [ "${OPEN_BROWSER}" != "" ]; then go tool cover -html="coverage-$@.out"; fi

.PHONY: docker-test-1.7-with-coverage
docker-test-1.7-with-coverage:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:1.7 \
	           /bin/sh -c "go list ./... | grep -v /vendor/ | xargs -n1 go get -d -t "$1" && \
	                       echo "mode: count" > "coverage-$@.out" && \
	                       for package in $$(go list ./... | grep -v /vendor/); do \
	                           go test -cover -covermode count -coverprofile "coverage-$@-$${package##*/}.out" "$${package}"; \
	                           sed '1d' "coverage-$@-$${package##*/}.out" >> "coverage-$@.out"; \
	                       done"
	if [ "${OPEN_BROWSER}" != "" ]; then go tool cover -html="coverage-$@.out"; fi

.PHONY: docker-test-latest-with-coverage
docker-test-latest-with-coverage:
	docker run --rm \
	           -v "${GOPATH}/src/${GO_PACKAGE}":"/go/src/${GO_PACKAGE}" \
	           -w "/go/src/${GO_PACKAGE}" \
	           golang:latest \
	           /bin/sh -c "go list ./... | grep -v /vendor/ | xargs -n1 go get -d -t "$1" && \
	                       echo "mode: count" > "coverage-$@.out" && \
	                       for package in $$(go list ./... | grep -v /vendor/); do \
	                           go test -cover -covermode count -coverprofile "coverage-$@-$${package##*/}.out" "$${package}"; \
	                           sed '1d' "coverage-$@-$${package##*/}.out" >> "coverage-$@.out"; \
	                       done"
	if [ "${OPEN_BROWSER}" != "" ]; then go tool cover -html="coverage-$@.out"; fi
