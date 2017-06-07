FROM alpine:latest

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

COPY artifacts/protoc artifacts/go-protobuf/* \
     artifacts/gogo-protobuf/* \
     /usr/local/bin/

RUN apk add --no-cache gcc g++

ENV PROTO_ARGS ''

WORKDIR /usr/share/pkg

CMD protoc ${PROTO_ARGS}
