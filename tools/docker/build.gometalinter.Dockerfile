FROM golang:alpine

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

WORKDIR /tmp

RUN apk add --no-cache ca-certificates git \
 && update-ca-certificates \
 && go get gopkg.in/alecthomas/gometalinter.v1 && mv /go/bin/gometalinter.v1 /go/bin/gometalinter \
 && export VERSION=$(cd /go/src/gopkg.in/alecthomas/gometalinter.v1 \
    && (git describe --tags 2> /dev/null || git rev-parse --short HEAD)) \
 && gometalinter --install \
 && export LINTERS=$(ls /go/bin/ | grep -v '^gometalinter$') \
 && mkdir gometalinter && mv /go/bin/* gometalinter/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \
 && touch meta.data \
 && echo "- [gometalinter](https://github.com/alecthomas/gometalinter).(${VERSION}," \
    "[diff](https://github.com/alecthomas/gometalinter/compare/${VERSION}...master))" >> meta.data \
 && for linter in $LINTERS; do echo "  - ${linter}" >> meta.data; done

CMD /bin/sh
