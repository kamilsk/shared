#
# Go package's environment variables.
#
# Version: 1.0
#

ifndef GOPATH
$(error $GOPATH not set)
endif

MAKEPATH   := $(abspath $(lastword $(MAKEFILE_LIST)))
PWD        := $(patsubst %/,%,$(dir $(MAKEPATH)))
GO_PACKAGE := $(patsubst %/,%,$(subst $(GOPATH)/src/,,$(dir $(abspath $(firstword $(MAKEFILE_LIST))))))

PACKAGES = go list ./... | grep -v /vendor/
