#
# Go package's docker environment.
#
# Version: 1.0
#

ARGS         =
OPEN_BROWSER =

SUPPORTED_VERSIONS ?= 1.5 1.6 1.7 latest

ifndef PWD
$(error Please include env.mk before)
endif

include $(PWD)/docker/bench-alpine.mk
include $(PWD)/docker/bench-alpine-gcc.mk
include $(PWD)/docker/bench-base.mk

include $(PWD)/docker/clean.mk

include $(PWD)/docker/pull-alpine.mk
include $(PWD)/docker/pull-alpine-gcc.mk
include $(PWD)/docker/pull-base.mk

include $(PWD)/docker/test-alpine.mk
include $(PWD)/docker/test-alpine-gcc.mk
include $(PWD)/docker/test-base.mk

include $(PWD)/docker/tooling.mk
