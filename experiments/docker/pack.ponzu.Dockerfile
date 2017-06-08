FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

COPY artifacts/ponzu/* /go/bin/

RUN apk add --no-cache git && go get -d github.com/ponzu-cms/ponzu/...

ENV PONZU_ARGS ''

CMD ponzu ${PONZU_ARGS}
