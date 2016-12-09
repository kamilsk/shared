#
# Temporary file for experiments.
#

include docker/clean.mk
include docker/pull-alpine.mk
include docker/pull-alpine-gcc.mk
include docker/pull-base.mk

.PHONY: docker-pull
docker-pull: docker-pull-1.5
docker-pull: docker-pull-1.6
docker-pull: docker-pull-1.7
docker-pull: docker-pull-latest
