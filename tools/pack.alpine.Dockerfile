FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

RUN apk update --no-cache \
 && apk add --no-cache gcc git libc-dev mercurial

COPY ./artifacts/easyjson       /go/bin/
COPY ./artifacts/glide          /go/bin/
COPY ./artifacts/gometalinter/* /go/bin/
COPY ./artifacts/goreleaser     /go/bin/
COPY ./artifacts/honnef/*       /go/bin/
