FROM golang:alpine

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

ARG BASE

WORKDIR /tmp

RUN apk add --no-cache ca-certificates git \
 && update-ca-certificates &>/dev/null \

 && go get honnef.co/go/tools/... \
 && export HGT=$(cd /go/src/honnef.co/go/tools \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && export HGT_LIST=$(ls /go/bin/) \
 && mkdir honnef && mv /go/bin/* honnef/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \

 && touch meta.data \
 && echo $'\n\
<<< START METADATA\n\
\n\
METADATA:short \n\
golang:alpine with honnef golang tools \n\
\n\
METADATA:full' >> meta.data \
 && echo "golang:alpine.(${BASE}) with " >> meta.data \

 && echo "- [honnef.co/go/tools](https://github.com/dominikh/go-tools).(${HGT}," \
    "[diff](https://github.com/dominikh/go-tools/compare/${HGT}...master))" >> meta.data \
 && for bin in $HGT_LIST; do echo "  - ${bin}" >> meta.data; done \

 && echo $'\n\
>>> END METADATA' >> meta.data

CMD /bin/sh
