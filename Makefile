.PHONY: build
build: build-go
build: build-js
build: build-jb
build: build-php
build: build-py
build: build-term

.PHONY: build-go
build-go:
	@echo "go build not ready"

.PHONY: build-js
build-js:
	@echo "javascript build not ready"

.PHONY: build-jb
build-jb:
	@echo "jetbrains build not ready"

.PHONY: build-php
build-php:
	@echo "php build not ready"

.PHONY: build-py
build-py:
	@echo "python build not ready"

.PHONY: build-term
build-term:
	@echo "terminal build not ready"
