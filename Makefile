MAKEPATH := $(abspath $(firstword $(MAKEFILE_LIST)))
CWD      := $(patsubst %/,%,$(dir $(MAKEPATH)))

include nginx/Makefile

.PHONY: clean
clean:
	@echo "not implemented yet"

.PHONY: build
build: build-nginx

.PHONY: process
process: process-nginx

.PHONY: publish
publish:
	@echo "not implemented yet"

.PHONY: pull
pull:
	@echo "not implemented yet"
