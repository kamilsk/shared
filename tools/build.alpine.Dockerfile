FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

ARG BASE
ARG GLIDE
ARG RELEASER

RUN apk update --no-cache \
 && apk add --no-cache ca-certificates git wget \
 && update-ca-certificates &>/dev/null \

 && go get github.com/mailru/easyjson/... \
 && export EJ=$(cd /go/src/github.com/mailru/easyjson \
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

 && go get honnef.co/go/tools/... \
 && export HGT=$(cd /go/src/honnef.co/go/tools \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mkdir /tmp/honnef && mv /go/bin/* /tmp/honnef/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \
 && export HGT_LIST=$(ls /tmp/honnef/) \

 && echo $'\n\
<<< START METADATA\n\
\n\
METADATA:short \n\
golang:alpine with git, mercurial, easyjson, glide, gometalinter, goreleaser and honnef.co/go/tools \n\
\n\
METADATA:full' >> /tmp/meta.data \
 && echo "golang:alpine.(${BASE}) with git and mercurial, and" >> /tmp/meta.data \
 && echo "- easyjson.(${HGT})" >> /tmp/meta.data \
 && echo "- glide.(${GLIDE})" >> /tmp/meta.data \
 && echo "- gometalinter.(${GML})" >> /tmp/meta.data \
 && for bin in $GML_LIST; do echo "  - ${bin}" >> /tmp/meta.data; done \
 && echo "- goreleaser.(${RELEASER})" >> /tmp/meta.data \
 && echo "- honnef.co/go/tools.(${HGT})" >> /tmp/meta.data \
 && for bin in $HGT_LIST; do echo "  - ${bin}" >> /tmp/meta.data; done \
 && echo $'\n\
[Dockerfile](https://github.com/kamilsk/shared/blob/docker-go-v1/tools) \n\
[Useful Makefile](https://github.com/kamilsk/shared/blob/makefile-go-v1/docker/tools.mk) \n\
\n\
>>> END METADATA' >> /tmp/meta.data

CMD ["sh"]
