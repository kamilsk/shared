FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

ARG BASE
ARG DEPTH
ARG REPORTER

WORKDIR /tmp

RUN apk add --no-cache ca-certificates git wget \
 && update-ca-certificates &>/dev/null \

 && go get github.com/bradleyfalzon/apicompat/... \
 && export ACMP=$(cd /go/src/github.com/bradleyfalzon/apicompat \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mkdir apicompat && mv /go/bin/* apicompat/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \

 && go get golang.org/x/tools/cmd/benchcmp \
 && export BCMP=$(cd /go/src/golang.org/x/tools/cmd/benchcmp \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mkdir benchcmp && mv /go/bin/* benchcmp/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \

 && wget -q -O depth \
    https://github.com/KyleBanks/depth/releases/download/v${DEPTH}/depth_${DEPTH}_linux_amd64 \
 && chmod +x depth \

 && go get github.com/google/godepq \
 && export GODEPQ=$(cd /go/src/github.com/google/godepq \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mkdir godepq && mv /go/bin/* godepq/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \

 && go get github.com/wgliang/goreporter \
 && export REPORTER=$(cd /go/src/github.com/wgliang/goreporter \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mkdir goreporter && mv /go/bin/* goreporter/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \

 && go get honnef.co/go/tools/... \
 && export HGT=$(cd /go/src/honnef.co/go/tools \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && export HGT_LIST=$(ls /go/bin/) \
 && mkdir honnef && mv /go/bin/* honnef/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \

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
golang:alpine with experimental golang tools \n\
\n\
METADATA:full' >> meta.data \
 && echo "golang:alpine.(${BASE}) with " >> meta.data \

 && echo "- [apicompat](https://abicheck.bradleyf.id.au).(${ACMP}," \
    "[diff](https://github.com/bradleyfalzon/apicompat/compare/${ACMP}...master))" >> meta.data \

 && echo "- [benchcmp](https://godoc.org/golang.org/x/tools/cmd/benchcmp).(${BCMP}," \
    "[src](https://github.com/golang/tools/tree/master/cmd/benchcmp))" >> meta.data \

 && echo "- [depth](https://github.com/KyleBanks/depth).(v${DEPTH}," \
    "[diff](https://github.com/KyleBanks/depth/compare/v${DEPTH}...master))" >> meta.data \

 && echo "- [godepq](https://github.com/google/godepq).(${GODEPQ}," \
    "[diff](https://github.com/google/godepq/compare/${GODEPQ}...master))" >> meta.data \

 && echo "- [goreporter](https://github.com/wgliang/goreporter).(${REPORTER}," \
    "[diff](https://github.com/wgliang/goreporter/compare/${REPORTER}...master))" >> meta.data \

 && echo "- [honnef.co/go/tools](https://github.com/dominikh/go-tools).(${HGT}," \
    "[diff](https://github.com/dominikh/go-tools/compare/${HGT}...master))" >> meta.data \
 && for bin in $HGT_LIST; do echo "  - ${bin}" >> meta.data; done \

 && echo "- [zb](https://jrubin.io/zb).(${ZB}," \
    "[diff](https://github.com/joshuarubin/zb/compare/${ZB}...master))" >> meta.data \

 && echo $'\n\
[Dockerfile](https://github.com/kamilsk/shared/blob/docker-go-v1/tools) \n\
[Useful Makefile](https://github.com/kamilsk/shared/blob/makefile-go-v1/docker/tools.mk) \n\
\n\
>>> END METADATA' >> meta.data

CMD /bin/sh
