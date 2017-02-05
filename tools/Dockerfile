FROM golang:latest

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

RUN go get gopkg.in/alecthomas/gometalinter.v1 \
 && mv /go/bin/gometalinter.v1 /go/bin/gometalinter \
 && gometalinter --install \
 && rm -rf /tmp/* /go/pkg/* /go/src/*

RUN curl https://glide.sh/get | sh \
 && rm -rf /tmp/* /go/pkg/* /go/src/*

RUN go get honnef.co/go/tools/... \
 && rm -rf /tmp/* /go/pkg/* /go/src/*
