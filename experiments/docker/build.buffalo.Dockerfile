FROM golang:alpine

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

ARG BASE
ARG VERSION

WORKDIR /tmp

RUN apk add --no-cache ca-certificates git \
 && update-ca-certificates &>/dev/null \
 && go get -d github.com/gobuffalo/buffalo/... \
 && (cd /go/src/github.com/gobuffalo/buffalo && git checkout v${VERSION} && rm -rf .git && go install ./...) \
 && mkdir buffalo && mv /go/bin/* buffalo/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \
 && touch meta.data \
 && echo $'\n\
<<< START METADATA\n\
\n\
METADATA:short \n\
golang:alpine with buffalo \n\
\n\
METADATA:full' >> meta.data \
 && echo "golang:alpine.(${BASE}) with " >> meta.data \
 && echo "- [buffalo](https://github.com/gobuffalo/buffalo).(${VERSION}," \
    "[diff](https://github.com/gobuffalo/buffalo/compare/${VERSION}...master))" >> meta.data \
 && echo $'\n\
>>> END METADATA' >> meta.data

CMD /bin/sh
