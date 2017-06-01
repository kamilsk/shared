FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

ARG BASE
ARG GLIDE
ARG RELEASER

RUN apk update --no-cache \
 && apk add --no-cache ca-certificates git wget \
 && update-ca-certificates &>/dev/null \

 && go get github.com/mailru/easyjson/... \
 && export EASYJSON=$(cd /go/src/github.com/mailru/easyjson \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mv /go/bin/easyjson /tmp/easyjson \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \

 && wget -q -O /tmp/glide.tar.gz \
    https://github.com/Masterminds/glide/releases/download/v${GLIDE}/glide-v${GLIDE}-linux-amd64.tar.gz \
 && mkdir /tmp/glide && tar xf /tmp/glide.tar.gz -C /tmp/glide \

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

 && echo $'\n\
<<< START METADATA\n\
\n\
METADATA:short \n\
golang:alpine with git, mercurial, glide, gometalinter, goreleaser and others (see full description) \n\
\n\
METADATA:full' >> /tmp/meta.data \
 && echo "golang:alpine.(${BASE}) with git and mercurial, and" >> /tmp/meta.data \

 && echo "- [easyjson](https://github.com/mailru/easyjson).(${EASYJSON}," \
    "[diff](https://github.com/mailru/easyjson/compare/${EASYJSON}...master))" >> /tmp/meta.data \

 && echo "- [glide](https://glide.sh).(v${GLIDE}," \
    "[diff](https://github.com/Masterminds/glide/compare/v${GLIDE}...master))" >> /tmp/meta.data \

 && echo "- [gometalinter](https://github.com/alecthomas/gometalinter).(${GML}," \
    "[diff](https://github.com/alecthomas/gometalinter/compare/${GML}...master))" >> /tmp/meta.data \
 && for bin in $GML_LIST; do echo "  - ${bin}" >> /tmp/meta.data; done \

 && echo "- [goreleaser](https://goreleaser.github.io).(v${RELEASER}," \
    "[diff](https://github.com/goreleaser/goreleaser/compare/v${RELEASER}...master))" >> /tmp/meta.data \

 && echo $'\n\
[Dockerfile](https://github.com/kamilsk/shared/blob/docker-go-v1/tools) \n\
[Useful Makefile](https://github.com/kamilsk/shared/blob/makefile-go-v1/docker/tools.mk) \n\
\n\
>>> END METADATA' >> /tmp/meta.data

CMD /bin/sh
