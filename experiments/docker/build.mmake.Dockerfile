FROM golang:alpine

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

ARG BASE
ARG MMAKE

WORKDIR /tmp

RUN apk add --no-cache ca-certificates git \
 && update-ca-certificates &>/dev/null \
 && go get -d github.com/tj/mmake/cmd/mmake \
 && (cd /go/src/github.com/tj/mmake && git checkout v${MMAKE} && rm -rf .git && go install ./...) \
 && mkdir mmake && mv /go/bin/* mmake/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \
 && touch meta.data \
 && echo $'\n\
<<< START METADATA\n\
\n\
METADATA:short \n\
golang:alpine with mmake \n\
\n\
METADATA:full' >> meta.data \
 && echo "golang:alpine.(${BASE}) with " >> meta.data \
 && echo "- [maintainer](https://github.com/tj/mmake).(v${MMAKE}," \
    "[diff](https://github.com/gaocegege/maintainer/compare/v${MMAKE}...master))" >> meta.data \
 && echo $'\n\
>>> END METADATA' >> meta.data

CMD /bin/sh
