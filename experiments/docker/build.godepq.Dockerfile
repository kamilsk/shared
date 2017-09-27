FROM golang:alpine

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

ARG BASE

WORKDIR /tmp

RUN apk add --no-cache ca-certificates git \
 && update-ca-certificates &>/dev/null \

 && go get github.com/google/godepq \
 && export GODEPQ=$(cd /go/src/github.com/google/godepq \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mkdir godepq && mv /go/bin/* godepq/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \

 && touch meta.data \
 && echo $'\n\
<<< START METADATA\n\
\n\
METADATA:short \n\
golang:alpine with godepq \n\
\n\
METADATA:full' >> meta.data \
 && echo "golang:alpine.(${BASE}) with " >> meta.data \

 && echo "- [godepq](https://github.com/google/godepq).(${GODEPQ}," \
    "[diff](https://github.com/google/godepq/compare/${GODEPQ}...master))" >> meta.data \

 && echo $'\n\
>>> END METADATA' >> meta.data

CMD /bin/sh
