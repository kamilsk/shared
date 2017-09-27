FROM golang:alpine

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

ARG BASE

WORKDIR /tmp

RUN apk add --no-cache ca-certificates git \
 && update-ca-certificates &>/dev/null \

 && go get golang.org/x/tools/cmd/benchcmp \
 && export BCMP=$(cd /go/src/golang.org/x/tools/cmd/benchcmp \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mkdir benchcmp && mv /go/bin/* benchcmp/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \

 && touch meta.data \
 && echo $'\n\
<<< START METADATA\n\
\n\
METADATA:short \n\
golang:alpine with benchcmp \n\
\n\
METADATA:full' >> meta.data \
 && echo "golang:alpine.(${BASE}) with " >> meta.data \

 && echo "- [benchcmp](https://godoc.org/golang.org/x/tools/cmd/benchcmp).(${BCMP}," \
    "[src](https://github.com/golang/tools/tree/master/cmd/benchcmp))" >> meta.data \

 && echo $'\n\
>>> END METADATA' >> meta.data

CMD /bin/sh
