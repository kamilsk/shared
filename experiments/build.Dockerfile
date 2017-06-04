FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

ARG BASE
ARG VERSION

WORKDIR /tmp

RUN apk add --no-cache ca-certificates git wget \
    gcc g++ musl-dev make pkgconfig libtool autoconf automake libuuid file curl \
 && update-ca-certificates &>/dev/null \

 && wget -q -O protoc.tar.gz \
    https://github.com/google/protobuf/archive/v${VERSION}.tar.gz \
 && tar xf protoc.tar.gz \
 && (cd protobuf-${VERSION} && ./autogen.sh -s && ./configure --disable-shared && make && make install) \
 && rm protoc.tar.gz \

 && go get github.com/golang/protobuf/protoc-gen-go \
 && export GPB=$(cd /go/src/github.com/golang/protobuf \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mkdir go-protobuf && mv /go/bin/* go-protobuf/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \

 && go get github.com/gogo/protobuf/... \
 && export GGPB=$(cd /go/src/github.com/gogo/protobuf \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && mkdir gogo-protobuf && mv /go/bin/* gogo-protobuf/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \

 && echo $'\n\
<<< START METADATA\n\
\n\
METADATA:short \n\
golang:alpine with gcc, g++, protoc and go protobuf plugins \n\
\n\
METADATA:full' >> /tmp/meta.data \
 && echo "golang:alpine.(${BASE}) with gcc and g++, and" >> /tmp/meta.data \

 && echo "- [protobuf](https://github.com/google/protobuf).(v${VERSION}," \
    "[diff](https://github.com/google/protobuf/compare/v${VERSION}...master))" >> /tmp/meta.data \

 && echo "- [golang/protobuf](https://github.com/golang/protobuf).(${GPB}," \
    "[diff](https://github.com/golang/protobuf/compare/${GPB}...master))" >> /tmp/meta.data \

 && echo "- [gogo/protobuf](https://github.com/gogo/protobuf).(${GGPB}," \
    "[diff](https://github.com/gogo/protobuf/compare/${GGPB}...master))" >> /tmp/meta.data \

 && echo $'\n\
>>> END METADATA' >> /tmp/meta.data

CMD /bin/sh
