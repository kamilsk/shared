FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

ARG BASE
ARG DEPTH
ARG REPORTER

RUN apk update --no-cache \
 && apk add --no-cache ca-certificates git wget \
 && update-ca-certificates &>/dev/null \

 && go get github.com/bradleyfalzon/apicompat/... \
 && export APICOMPAT=$(cd /go/src/github.com/bradleyfalzon/apicompat \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mv /go/bin/apicompat /tmp/apicompat \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \

 && go get golang.org/x/tools/cmd/benchcmp \
 && export BENCHCMP=$(cd /go/src/golang.org/x/tools/cmd/benchcmp \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mv /go/bin/benchcmp /tmp/benchcmp \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \

 && wget -q -O /tmp/depth \
    https://github.com/KyleBanks/depth/releases/download/v${DEPTH}/depth_${DEPTH}_linux_amd64 \
 && chmod +x /tmp/depth \

 && go get github.com/google/godepq \
 && export GODEPQ=$(cd /go/src/github.com/google/godepq \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mv /go/bin/godepq /tmp/godepq \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \

 && go get github.com/wgliang/goreporter \
 && export REPORTER=$(cd /go/src/github.com/wgliang/goreporter \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mv /go/bin/goreporter /tmp/goreporter \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \

 && go get honnef.co/go/tools/... \
 && export HGT=$(cd /go/src/honnef.co/go/tools \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mkdir /tmp/honnef && mv /go/bin/* /tmp/honnef/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \
 && export HGT_LIST=$(ls /tmp/honnef/) \

 && go get jrubin.io/zb \
 && export ZB=$(cd /go/src/jrubin.io/zb \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mv /go/bin/zb /tmp/zb \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \

 && echo $'\n\
<<< START METADATA\n\
\n\
METADATA:short \n\
golang:alpine with experimental golang tools \n\
\n\
METADATA:full' >> /tmp/meta.data \
 && echo "golang:alpine.(${BASE}) with " >> /tmp/meta.data \

 && echo "- [apicompat](https://abicheck.bradleyf.id.au).(${APICOMPAT}," \
    "[diff](https://github.com/bradleyfalzon/apicompat/compare/${APICOMPAT}...master))" >> /tmp/meta.data \

 && echo "- [benchcmp](https://godoc.org/golang.org/x/tools/cmd/benchcmp).(${BENCHCMP}," \
    "[src](https://github.com/golang/tools/tree/master/cmd/benchcmp))" >> /tmp/meta.data \

 && echo "- [depth](https://github.com/KyleBanks/depth).(v${DEPTH}," \
    "[diff](https://github.com/KyleBanks/depth/compare/v${DEPTH}...master))" >> /tmp/meta.data \

 && echo "- [godepq](https://github.com/google/godepq).(${GODEPQ}," \
    "[diff](https://github.com/google/godepq/compare/${GODEPQ}...master))" >> /tmp/meta.data \

 && echo "- [goreporter](https://github.com/wgliang/goreporter).(${REPORTER}," \
    "[diff](https://github.com/wgliang/goreporter/${REPORTER}...master))" >> /tmp/meta.data \

 && echo "- [honnef.co/go/tools](https://github.com/dominikh/go-tools).(${HGT}," \
    "[diff](https://github.com/dominikh/go-tools/compare/${HGT}...master))" >> /tmp/meta.data \
 && for bin in $HGT_LIST; do echo "  - ${bin}" >> /tmp/meta.data; done \

 && echo "- [zb](https://jrubin.io/zb).(${ZB}," \
    "[diff](https://github.com/joshuarubin/zb/compare/${ZB}...master))" >> /tmp/meta.data \

 && echo $'\n\
[Dockerfile](https://github.com/kamilsk/shared/blob/docker-go-v1/tools) \n\
[Useful Makefile](https://github.com/kamilsk/shared/blob/makefile-go-v1/docker/tools.mk) \n\
\n\
>>> END METADATA' >> /tmp/meta.data

CMD /bin/sh
