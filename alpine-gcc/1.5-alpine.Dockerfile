FROM golang:1.5-alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

ENV GOPATH /go

RUN apk add --no-cache gcc git musl-dev
