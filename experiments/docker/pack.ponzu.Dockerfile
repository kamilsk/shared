FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

COPY artifacts/ponzu/*     /go/bin/

ENV PONZU_ARGS ''

CMD ponzu ${PONZU_ARGS}
