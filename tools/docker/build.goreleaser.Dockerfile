FROM alpine:latest

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

ARG VERSION

WORKDIR /tmp

RUN apk add --no-cache ca-certificates wget \
 && update-ca-certificates &>/dev/null \
 && wget -q -O goreleaser.tar.gz \
    https://github.com/goreleaser/goreleaser/releases/download/v${VERSION}/goreleaser_Linux_x86_64.tar.gz \
 && mkdir goreleaser && tar xf goreleaser.tar.gz -C goreleaser/ \
 && rm goreleaser.tar.gz \
 && touch meta.data \
 && echo "- [goreleaser](https://goreleaser.github.io).(v${VERSION}," \
    "[diff](https://github.com/goreleaser/goreleaser/compare/v${VERSION}...master))" >> meta.data 

CMD /bin/sh
