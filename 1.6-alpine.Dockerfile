FROM golang:1.6-alpine

MAINTAINER Kamil Samigullin

ENV GOPATH /go

RUN apk add --no-cache gcc musl-dev
