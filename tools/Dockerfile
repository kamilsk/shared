FROM golang:latest

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

RUN go get gopkg.in/alecthomas/gometalinter.v1 \
 && gometalinter.v1 --install \
 && rm -rf /tmp/* /go/pkg/* /go/src/*

RUN curl https://glide.sh/get | sh \
 && rm -rf /tmp/* /go/pkg/* /go/src/*
