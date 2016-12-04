#
# Go package's environment variables.
#
# Version: 1.0
#

MAKEPATH := $(abspath $(lastword $(MAKEFILE_LIST)))
PWD := $(dir $(MAKEPATH))
