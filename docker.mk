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

include $(PWD)/docker/alpine.mk
include $(PWD)/docker/alpine-gcc.mk
include $(PWD)/docker/base.mk

include $(PWD)/docker/clean.mk

include $(PWD)/docker/tools.mk
