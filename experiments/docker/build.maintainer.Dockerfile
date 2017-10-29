FROM golang:alpine

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

ARG BASE
ARG MAINTAINER

WORKDIR /tmp

RUN apk add --no-cache ca-certificates git \
 && update-ca-certificates &>/dev/null \
 && go get -d github.com/gaocegege/maintainer \
 && (cd /go/src/github.com/gaocegege/maintainer && git checkout v${MAINTAINER} && rm -rf .git && go install ./...) \
 && mkdir maintainer && mv /go/bin/* maintainer/ \
 && rm -rf /go/bin/* /go/pkg/* /go/src/* \
 && touch meta.data \
 && echo $'\n\
<<< START METADATA\n\
\n\
METADATA:short \n\
golang:alpine with maintainer \n\
\n\
METADATA:full' >> meta.data \
 && echo "golang:alpine.(${BASE}) with " >> meta.data \
 && echo "- [maintainer](https://github.com/gaocegege/maintainer).(v${MAINTAINER}," \
    "[diff](https://github.com/gaocegege/maintainer/compare/v${MAINTAINER}...master))" >> meta.data \
 && echo $'\n\
>>> END METADATA' >> meta.data

CMD /bin/sh
