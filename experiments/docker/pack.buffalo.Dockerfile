FROM golang:alpine

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

COPY artifacts/buffalo/* /go/bin/

ENV BUFFALO_ARGS ''

CMD buffalo ${BUFFALO_ARGS}
