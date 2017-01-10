define docker_base_tpl

.PHONY: docker-bench-$(1)
docker-bench-$(1):
	docker run --rm \
	           -v '$${GOPATH}/src/$${GO_PACKAGE}':'/go/src/$${GO_PACKAGE}' \
	           -w '/go/src/$${GO_PACKAGE}' \
	           golang:$(1) \
	           /bin/sh -c '$$(PACKAGES) | xargs go get -d -t "$$$$1" && \
	                       $$(PACKAGES) | xargs go test -bench=. $$(strip $$(ARGS)) "$$$$1"'

.PHONY: docker-pull-$(1)
docker-pull-$(1):
	docker pull golang:$(1)

.PHONY: docker-test-$(1)
docker-test-$(1):
	docker run --rm \
	           -v '$${GOPATH}/src/$${GO_PACKAGE}':'/go/src/$${GO_PACKAGE}' \
	           -w '/go/src/$${GO_PACKAGE}' \
	           golang:$(1) \
	           /bin/sh -c '$$(PACKAGES) | xargs go get -d -t "$$$$1" && \
	                       $$(PACKAGES) | xargs go test -race $$(strip $$(ARGS)) "$$$$1"'

.PHONY: docker-test-$(1)-with-coverage
docker-test-$(1)-with-coverage:
	docker run --rm \
	           -v '$${GOPATH}/src/$${GO_PACKAGE}':'/go/src/$${GO_PACKAGE}' \
	           -w '/go/src/$${GO_PACKAGE}' \
	           golang:$(1) \
	           /bin/sh -c 'go list ./... | grep -v /vendor/ | xargs go get -d -t "$$$$1"; \
	                       echo "mode: $${GO_TEST_COVERAGE_MODE}" > '$$@.out'; \
	                       for package in $$$$($$(PACKAGES)); do \
	                           go test -covermode '$${GO_TEST_COVERAGE_MODE}' \
	                                   -coverprofile "coverage_$$$${package##*/}.out" \
	                                   $$(strip $$(ARGS)) "$$$${package}"; \
	                           sed '1d' "coverage_$$$${package##*/}.out" >> '$$@.out'; \
	                           rm "coverage_$$$${package##*/}.out"; \
	                       done'
	if [ '$$(OPEN_BROWSER)' != '' ]; then go tool cover -html='$$@.out'; fi

endef
$(foreach v,$(SUPPORTED_VERSIONS),$(eval $(call docker_base_tpl,$(v))))
