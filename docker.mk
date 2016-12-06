#
# Go package's docker environment.
#
# Version: 1.0
#

ifndef GO_PACKAGE
$(error Please provide GO_PACKAGE (e.g. GO_PACKAGE:="github.com/kamilsk/semaphore"))
endif

include $(PWD)docker/bench-alpine.mk
include $(PWD)docker/bench-alpine-gcc.mk
include $(PWD)docker/bench-base.mk

include $(PWD)docker/deps-alpine.mk
include $(PWD)docker/deps-alpine-gcc.mk
include $(PWD)docker/deps-base.mk

include $(PWD)docker/test-alpine.mk
include $(PWD)docker/test-alpine-gcc.mk
include $(PWD)docker/test-base.mk
