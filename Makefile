.PHONY: build
build: build-awsm
build: build-br
build: build-css
build: build-go
build: build-js
build: build-jb
build: build-php
build: build-py
build: build-term

.PHONY: build-awsm
build-awsm:
	go run cmd/build.go -s awesome

.PHONY: build-br
build-br:
	@echo "browser build not ready"

.PHONY: build-css
build-css:
	go run cmd/build.go -s css -d 'My collection of useful CSS packages'

.PHONY: build-go
build-go:
	go run cmd/build.go -s go -d 'My collection of useful Go packages'

.PHONY: build-js
build-js:
	go run cmd/build.go -s javascript -d 'My collection of useful JavaScript packages'

.PHONY: build-jb
build-jb:
	@echo "jetbrains build not ready"

.PHONY: build-php
build-php:
	go run cmd/build.go -s php -d 'My collection of useful PHP packages'

.PHONY: build-py
build-py:
	go run cmd/build.go -s python -d 'My collection of useful Python packages'

.PHONY: build-term
build-term:
	@echo "terminal build not ready"
