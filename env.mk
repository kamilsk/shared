ifndef GOPATH
$(error $GOPATH not set)
endif


MAKEPATH   := $(abspath $(lastword $(MAKEFILE_LIST)))
PWD        := $(patsubst %/,%,$(dir $(MAKEPATH)))
DATE       := $(shell date -u "+%Y-%m-%d %H:%M:%S")
GO_VERSION := $(shell go version | awk '{print $$3}' | tr -d 'go')

GIT_REV    := $(shell git rev-parse --short HEAD)
GO_PACKAGE := $(patsubst %/,%,$(subst $(GOPATH)/src/,,$(dir $(abspath $(firstword $(MAKEFILE_LIST))))))

ARGS     =
PACKAGES = go list ./... | grep -v /vendor/