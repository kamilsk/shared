FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

ARG BASE
ARG REPORTER

WORKDIR /tmp

RUN apk add --no-cache ca-certificates git \
 && update-ca-certificates &>/dev/null \

 && go get github.com/360EntSecGroup-Skylar/goreporter \
 && export REPORTER=$(cd /go/src/github.com/360EntSecGroup-Skylar/goreporter \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mkdir goreporter && mv /go/bin/* goreporter/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \

 && touch meta.data \
 && echo $'\n\
<<< START METADATA\n\
\n\
METADATA:short \n\
golang:alpine with goreporter \n\
\n\
METADATA:full' >> meta.data \
 && echo "golang:alpine.(${BASE}) with " >> meta.data \

 && echo "- [goreporter](https://github.com/360EntSecGroup-Skylar/goreporter).(${REPORTER}," \
    "[diff](https://github.com/360EntSecGroup-Skylar/goreporter/compare/${REPORTER}...master))" >> meta.data \

 && echo $'\n\
>>> END METADATA' >> meta.data

CMD /bin/sh
