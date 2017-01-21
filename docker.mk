ifndef PWD
$(error Please include env.mk before)
endif


DOCKER_VERSION := $(shell docker version | grep Version | head -1 | awk '{print $$2}')

OPEN_BROWSER       ?= true
SUPPORTED_VERSIONS ?= 1.5 1.6 1.7 latest

include $(PWD)/docker/alpine.mk
include $(PWD)/docker/alpine-gcc.mk
include $(PWD)/docker/base.mk

include $(PWD)/docker/clean.mk

include $(PWD)/docker/tools.mk
