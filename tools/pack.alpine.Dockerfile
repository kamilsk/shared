FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

# gcc and libc-dev for gometalinter
# git and mercurial for glide and go get
RUN apk update --no-cache \
 && apk add --no-cache gcc git libc-dev mercurial

COPY ./artifacts/apicompat      /go/bin/
COPY ./artifacts/benchcmp       /go/bin/
COPY ./artifacts/easyjson       /go/bin/
COPY ./artifacts/glide          /go/bin/
COPY ./artifacts/godepq         /go/bin/
COPY ./artifacts/gometalinter/* /go/bin/
COPY ./artifacts/goreleaser     /go/bin/
COPY ./artifacts/goreporter     /go/bin/
COPY ./artifacts/honnef/*       /go/bin/
COPY ./artifacts/zb             /go/bin/
