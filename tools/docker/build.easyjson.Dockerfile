FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

WORKDIR /tmp

RUN apk add --no-cache ca-certificates git \
 && update-ca-certificates \

 && go get github.com/mailru/easyjson/... \
 && export VERSION=$(cd /go/src/github.com/mailru/easyjson \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mkdir easyjson && mv /go/bin/* easyjson/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \

 && touch meta.data \
 && echo "- [easyjson](https://github.com/mailru/easyjson).(${VERSION}," \
    "[diff](https://github.com/mailru/easyjson/compare/${VERSION}...master))" >> meta.data

CMD /bin/sh
