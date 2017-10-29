FROM golang:alpine

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

ARG BASE

WORKDIR /tmp

RUN apk add --no-cache ca-certificates git \
 && update-ca-certificates &>/dev/null \
 && go get jrubin.io/zb \
 && export ZB=$(cd /go/src/jrubin.io/zb \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mkdir zb && mv /go/bin/* zb/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \
 && touch meta.data \
 && echo $'\n\
<<< START METADATA\n\
\n\
METADATA:short \n\
golang:alpine with zb \n\
\n\
METADATA:full' >> meta.data \
 && echo "golang:alpine.(${BASE}) with " >> meta.data \
 && echo "- [zb](https://jrubin.io/zb).(${ZB}," \
    "[diff](https://github.com/joshuarubin/zb/compare/${ZB}...master))" >> meta.data \
 && echo $'\n\
>>> END METADATA' >> meta.data

CMD /bin/sh
