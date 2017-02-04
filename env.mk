ifndef GOPATH
$(error $GOPATH not set)
endif


CWD        := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))
CID        := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
DATE       := $(shell date -u "+%Y-%m-%d %H:%M:%S")
GO_VERSION := $(shell go version | awk '{print $$3}' | tr -d 'go')

GIT_REV    := $(shell git rev-parse --short HEAD)
GO_PACKAGE := $(patsubst %/,%,$(subst $(GOPATH)/src/,,$(CWD)))

ARGS     =
PACKAGES = go list ./... | grep -v /vendor/
define BUILD_VARIATION = (
    [android]   = [arm],
    [darwin]    = [386, amd64, arm, arm64],
    [dragonfly] = [amd64],
    [freebsd]   = [386, amd64, arm],
    [linux]     = [386, amd64, arm, arm64, ppc64, ppc64le, mips64, mips64le],
    [netbsd]    = [386, amd64, arm],
    [openbsd]   = [386, amd64, arm],
    [plan9]     = [386, amd64],
    [solaris]   = [amd64],
    [windows]   = [386, amd64],
)
endef
