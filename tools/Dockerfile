FROM golang:latest

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

RUN go get gopkg.in/alecthomas/gometalinter.v1
RUN gometalinter.v1 --install

RUN curl https://glide.sh/get | sh

RUN rm -rf /go/pkg/* /go/src/*
