MAKEPATH := $(abspath $(firstword $(MAKEFILE_LIST)))
CWD      := $(patsubst %/,%,$(dir $(MAKEPATH)))

.PHONY: clean
clean:
	@echo "not implemented yet"

.PHONY: build
build:
	@echo "not implemented yet"

.PHONY: process
process:
	@echo "not implemented yet"

.PHONY: publish
publish:
	@echo "not implemented yet"

.PHONY: pull
pull:
	@echo "not implemented yet"
