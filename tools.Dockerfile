FROM golang:alpine

MAINTAINER Kamil Samigullin

ENV GOPATH /go

RUN apk add --no-cache git
RUN mkdir -p /go/bin /go/pkg /go/src
RUN go get gopkg.in/alecthomas/gometalinter.v1
RUN gometalinter.v1 --install
