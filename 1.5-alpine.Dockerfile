FROM golang:1.5-alpine

MAINTAINER Kamil Samigullin

ENV GOPATH /go

RUN apk add --no-cache gcc musl-dev
