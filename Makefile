.PHONY: build
build: build-go
build: build-jetbrains
build: build-php
build: build-python

.PHONY: build-go
build-go:
	@echo "go build not ready"

.PHONY: build-jetbrains
build-jetbrains:
	@echo "jetbrains build not ready"

.PHONY: build-php
build-php:
	@echo "php build not ready"

.PHONY: build-python
build-python:
	@echo "python build not ready"
