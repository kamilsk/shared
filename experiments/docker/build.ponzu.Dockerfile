FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

ARG BASE
ARG VERSION

WORKDIR /tmp

RUN apk add --no-cache ca-certificates git \
 && update-ca-certificates &>/dev/null \

 && go get -d github.com/ponzu-cms/ponzu/... \
 && (cd /go/src/github.com/ponzu-cms/ponzu && git checkout ${VERSION} && rm -rf .git && go install ./...) \
 && mkdir ponzu && mv /go/bin/* ponzu/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \

 && touch meta.data \
 && echo $'\n\
<<< START METADATA\n\
\n\
METADATA:short \n\
golang:alpine with ponzu \n\
\n\
METADATA:full' >> meta.data \
 && echo "golang:alpine.(${BASE}) with " >> meta.data \

 && echo "- [ponzu](https://github.com/ponzu-cms/ponzu).(${VERSION}," \
    "[diff](https://github.com/ponzu-cms/ponzu/compare/${VERSION}...master))" >> meta.data \

 && echo $'\n\
>>> END METADATA' >> meta.data

CMD /bin/sh
