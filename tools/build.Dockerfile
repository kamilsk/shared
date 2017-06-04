FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

ARG BASE
ARG GLIDE
ARG RELEASER
ARG RETRY

WORKDIR /tmp

RUN apk add --no-cache ca-certificates git wget \
 && update-ca-certificates &>/dev/null \

 && go get github.com/mailru/easyjson/... \
 && export EJ=$(cd /go/src/github.com/mailru/easyjson \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mkdir easyjson && mv /go/bin/* easyjson/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \

 && wget -q -O glide.tar.gz \
    https://github.com/Masterminds/glide/releases/download/v${GLIDE}/glide-v${GLIDE}-linux-amd64.tar.gz \
 && mkdir glide && tar xf glide.tar.gz -C glide/ \
 && rm glide.tar.gz \

 && go get gopkg.in/alecthomas/gometalinter.v1 && mv /go/bin/gometalinter.v1 /go/bin/gometalinter \
 && export GML=$(cd /go/src/gopkg.in/alecthomas/gometalinter.v1 \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && gometalinter --install \
 && export GML_LIST=$(ls /go/bin/ | grep -v '^gometalinter$') \
 && mkdir gometalinter && mv /go/bin/* gometalinter/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \

 && wget -q -O goreleaser.tar.gz \
    https://github.com/goreleaser/goreleaser/releases/download/v${RELEASER}/goreleaser_Linux_x86_64.tar.gz \
 && mkdir goreleaser && tar xf goreleaser.tar.gz -C goreleaser/ \
 && rm goreleaser.tar.gz \

 && wget -q -O retry.tar.gz \
    https://github.com/kamilsk/retry/releases/download/${RETRY}/retry_${RETRY}_Linux-64bit.tar.gz \
 && mkdir retry && tar xf retry.tar.gz -C retry/ \
 && rm retry.tar.gz \

 && touch meta.data \
 && echo $'\n\
<<< START METADATA\n\
\n\
METADATA:short \n\
golang:alpine with git, mercurial, glide, gometalinter, goreleaser and others (see full description) \n\
\n\
METADATA:full' >> meta.data \
 && echo "golang:alpine.(${BASE}) with git and mercurial, and" >> meta.data \

 && echo "- [easyjson](https://github.com/mailru/easyjson).(${EJ}," \
    "[diff](https://github.com/mailru/easyjson/compare/${EJ}...master))" >> meta.data \

 && echo "- [glide](https://glide.sh).(v${GLIDE}," \
    "[diff](https://github.com/Masterminds/glide/compare/v${GLIDE}...master))" >> meta.data \

 && echo "- [gometalinter](https://github.com/alecthomas/gometalinter).(${GML}," \
    "[diff](https://github.com/alecthomas/gometalinter/compare/${GML}...master))" >> meta.data \
 && for bin in $GML_LIST; do echo "  - ${bin}" >> meta.data; done \

 && echo "- [goreleaser](https://goreleaser.github.io).(v${RELEASER}," \
    "[diff](https://github.com/goreleaser/goreleaser/compare/v${RELEASER}...master))" >> meta.data \

 && echo "- [retry](https://github.com/kamilsk/retry).(${RETRY}," \
    "[diff](https://github.com/kamilsk/retry/compare/${RETRY}...master))" >> meta.data \

 && echo $'\n\
[Dockerfile](https://github.com/kamilsk/shared/blob/docker-go-v1/tools) \n\
[Useful Makefile](https://github.com/kamilsk/shared/blob/makefile-go-v1/docker/tools.mk) \n\
\n\
>>> END METADATA' >> meta.data

CMD /bin/sh
