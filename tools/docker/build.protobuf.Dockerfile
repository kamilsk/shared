FROM golang:alpine

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

ARG VERSION

WORKDIR /tmp

RUN apk add --no-cache ca-certificates git wget \
    gcc g++ musl-dev make pkgconfig libtool autoconf automake libuuid file curl \
 && update-ca-certificates &>/dev/null \

 && wget -q -O protoc.tar.gz \
    https://github.com/google/protobuf/archive/v${VERSION}.tar.gz \
 && tar xf protoc.tar.gz \
 && (cd protobuf-${VERSION} && ./autogen.sh -s && ./configure --disable-shared && make && make install) \
 && mkdir protoc && mv /usr/local/bin/protoc protoc/ \
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

 && touch meta.data \
 && echo "- [protobuf](https://developers.google.com/protocol-buffers/).(v${VERSION}," \
    "[diff](https://github.com/google/protobuf/compare/v${VERSION}...master))" >> /tmp/meta.data \

 && echo "- [golang/protobuf](https://github.com/golang/protobuf).(${GPB}," \
    "[diff](https://github.com/golang/protobuf/compare/${GPB}...master))" >> /tmp/meta.data \

 && echo "- [gogo/protobuf](https://github.com/gogo/protobuf).(${GGPB}," \
    "[diff](https://github.com/gogo/protobuf/compare/${GGPB}...master))" >> /tmp/meta.data

CMD /bin/sh
