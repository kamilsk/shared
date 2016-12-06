FROM golang:1.7-alpine

MAINTAINER Kamil Samigullin

ENV GOPATH /go

RUN apk add --no-cache gcc git musl-dev
