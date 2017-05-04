FROM golang:latest

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

ARG BASE
ENV GLIDE_VERSION 0.12.3
ENV GORELEASER_VERSION 0.17.1

RUN wget -q -O /tmp/glide.tar.gz https://github.com/Masterminds/glide/releases/download/v${GLIDE_VERSION}/glide-v${GLIDE_VERSION}-linux-amd64.tar.gz \
 && tar xf /tmp/glide.tar.gz -C /tmp \
 && cp /tmp/linux-amd64/glide /go/bin \
 && rm -rf /tmp/* /go/pkg/* /go/src/* \

 && go get gopkg.in/alecthomas/gometalinter.v1 \
 && export GML_VERSION=$(cd /go/src/gopkg.in/alecthomas/gometalinter.v1 && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mv /go/bin/gometalinter.v1 /go/bin/gometalinter \
 && gometalinter --install \
 && rm -rf /tmp/* /go/pkg/* /go/src/* \

 && wget -q -O /tmp/goreleaser.tar.gz https://github.com/goreleaser/goreleaser/releases/download/v${GORELEASER_VERSION}/goreleaser_Linux_x86_64.tar.gz \
 && tar xf /tmp/goreleaser.tar.gz -C /tmp \
 && cp /tmp/goreleaser /go/bin \
 && rm -rf /tmp/* /go/pkg/* /go/src/* \

 && go get honnef.co/go/tools/... \
 && export GT_VERSION=$(cd /go/src/honnef.co/go/tools && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && rm -rf /tmp/* /go/pkg/* /go/src/* \
 && echo '\n\
<<< START METADATA\n\
\n\
METADATA:short \n\
golang:latest with glide, gometalinter, goreleaser and honnef.co/go/tools \n\
\n\
METADATA:full' \
 && echo "golang:latest.(${BASE}) with" \
 && echo "- glide.(${GLIDE_VERSION})" \
 && echo "- gometalinter.(${GML_VERSION})" \
 && echo "- goreleaser.(${GORELEASER_VERSION})" \
 && echo "- honnef.co/go/tools.(${GT_VERSION})" \
 && echo '\n\
[Dockerfile](https://github.com/kamilsk/shared/blob/docker-go-v1/tools/Dockerfile).\n\
[Useful Makefile](https://github.com/kamilsk/shared/blob/makefile-go-v1/docker/tools.mk).\n\
\n\
>>> END METADATA\n'
