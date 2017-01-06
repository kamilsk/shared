FROM golang:latest

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

ENV GOPATH /go

RUN mkdir -p /go/bin /go/pkg /go/src
RUN go get gopkg.in/alecthomas/gometalinter.v1
RUN gometalinter.v1 --install
