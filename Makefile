.PHONY: build
build: build-br
build: build-go
build: build-js
build: build-jb
build: build-php
build: build-py
build: build-term

.PHONY: build-br
build-br:
	@echo "browser build not ready"

.PHONY: build-go
build-go:
	go run cmd/build.go -s go -n Go

.PHONY: build-js
build-js:
	go run cmd/build.go -s javascript -n JavaScript

.PHONY: build-jb
build-jb:
	@echo "jetbrains build not ready"

.PHONY: build-php
build-php:
	go run cmd/build.go -s php -n PHP

.PHONY: build-py
build-py:
	go run cmd/build.go -s python -n Python

.PHONY: build-term
build-term:
	@echo "terminal build not ready"
