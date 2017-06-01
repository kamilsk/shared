FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

COPY ./artifacts/apicompat      /go/bin/
COPY ./artifacts/benchcmp       /go/bin/
COPY ./artifacts/depth          /go/bin/
COPY ./artifacts/godepq         /go/bin/
COPY ./artifacts/goreporter     /go/bin/
COPY ./artifacts/honnef/*       /go/bin/
COPY ./artifacts/zb             /go/bin/
