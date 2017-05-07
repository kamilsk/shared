FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

ARG BASE
ARG GLIDE
ARG RELEASER
# TODO use when egg will ready, update metadata (add prefix "version-")
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

 && go get github.com/mailru/easyjson/... \
 && export EASYJSON=$(cd /go/src/github.com/mailru/easyjson \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mv /go/bin/easyjson /tmp/easyjson \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \

 && wget -q -O /tmp/glide.tar.gz \
    https://github.com/Masterminds/glide/releases/download/v${GLIDE}/glide-v${GLIDE}-linux-amd64.tar.gz \
 && mkdir /tmp/glide && tar xf /tmp/glide.tar.gz -C /tmp/glide \

 && go get github.com/google/godepq \
 && export GODEPQ=$(cd /go/src/github.com/google/godepq \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mv /go/bin/godepq /tmp/godepq \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \

 && go get gopkg.in/alecthomas/gometalinter.v1 \
 && export GML=$(cd /go/src/gopkg.in/alecthomas/gometalinter.v1 \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mv /go/bin/gometalinter.v1 /go/bin/gometalinter \
 && gometalinter --install \
 && mkdir /tmp/gometalinter && mv /go/bin/* /tmp/gometalinter/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \
 && export GML_LIST=$(ls /tmp/gometalinter/) \

 && wget -q -O /tmp/goreleaser.tar.gz \
    https://github.com/goreleaser/goreleaser/releases/download/v${RELEASER}/goreleaser_Linux_x86_64.tar.gz \
 && mkdir /tmp/goreleaser && tar xf /tmp/goreleaser.tar.gz -C /tmp/goreleaser \

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
golang:alpine with git, mercurial, glide, gometalinter, goreleaser and others (see full description) \n\
\n\
METADATA:full' >> /tmp/meta.data \
 && echo "golang:alpine.(${BASE}) with git and mercurial, and" >> /tmp/meta.data \

 && echo "- [apicompat](https://abicheck.bradleyf.id.au).(${APICOMPAT}," \
    "[diff](https://github.com/bradleyfalzon/apicompat/compare/${APICOMPAT}...master))" >> /tmp/meta.data \

 && echo "- [benchcmp](https://godoc.org/golang.org/x/tools/cmd/benchcmp).(${BENCHCMP}," \
    "[src](https://github.com/golang/tools/tree/master/cmd/benchcmp))" >> /tmp/meta.data \

 && echo "- [easyjson](https://github.com/mailru/easyjson).(${EASYJSON}," \
    "[diff](https://github.com/mailru/easyjson/compare/${EASYJSON}...master))" >> /tmp/meta.data \

 && echo "- [glide](https://glide.sh).(v${GLIDE}," \
    "[diff](https://github.com/Masterminds/glide/compare/v${GLIDE}...master))" >> /tmp/meta.data \

 && echo "- [godepq](https://github.com/google/godepq).(v${GODEPQ}," \
    "[diff](https://github.com/google/godepq/compare/${GODEPQ}...master))" >> /tmp/meta.data \

 && echo "- [gometalinter](https://github.com/alecthomas/gometalinter).(${GML}," \
    "[diff](https://github.com/alecthomas/gometalinter/compare/${GML}...master))" >> /tmp/meta.data \
 && for bin in $GML_LIST; do echo "  - ${bin}" >> /tmp/meta.data; done \

 && echo "- [goreleaser](https://goreleaser.github.io).(v${RELEASER}," \
    "[diff](https://github.com/goreleaser/goreleaser/compare/v${RELEASER}...master))" >> /tmp/meta.data \

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

CMD ["sh"]
