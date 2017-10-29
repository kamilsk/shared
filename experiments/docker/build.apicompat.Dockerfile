FROM golang:alpine

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

ARG BASE

WORKDIR /tmp

RUN apk add --no-cache ca-certificates git \
 && update-ca-certificates &>/dev/null \
 && go get github.com/bradleyfalzon/apicompat/... \
 && export ACMP=$(cd /go/src/github.com/bradleyfalzon/apicompat \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mkdir apicompat && mv /go/bin/* apicompat/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \
 && touch meta.data \
 && echo $'\n\
<<< START METADATA\n\
\n\
METADATA:short \n\
golang:alpine with apicompat \n\
\n\
METADATA:full' >> meta.data \
 && echo "golang:alpine.(${BASE}) with " >> meta.data \
 && echo "- [apicompat](https://abicheck.bradleyf.id.au).(${ACMP}," \
    "[diff](https://github.com/bradleyfalzon/apicompat/compare/${ACMP}...master))" >> meta.data \
 && echo $'\n\
>>> END METADATA' >> meta.data

CMD /bin/sh
