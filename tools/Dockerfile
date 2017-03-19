FROM golang:latest

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

ENV GLIDE_VERSION 0.12.3

RUN go get gopkg.in/alecthomas/gometalinter.v1 \
 && mv /go/bin/gometalinter.v1 /go/bin/gometalinter \
 && gometalinter --install \
 && rm -rf /tmp/* /go/pkg/* /go/src/*

RUN wget -q -O /tmp/glide.tar.gz https://github.com/Masterminds/glide/releases/download/v${GLIDE_VERSION}/glide-v${GLIDE_VERSION}-linux-amd64.tar.gz \
 && tar xf /tmp/glide.tar.gz -C /tmp \
 && cp /tmp/linux-amd64/glide /go/bin \
 && rm -rf /tmp/* /go/pkg/* /go/src/*

RUN go get honnef.co/go/tools/... \
 && rm -rf /tmp/* /go/pkg/* /go/src/*
