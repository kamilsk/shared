FROM alpine:latest

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

ARG VERSION

WORKDIR /tmp

RUN apk add --no-cache ca-certificates wget \
 && update-ca-certificates \
 && wget -q -O dep \
    https://github.com/golang/dep/releases/download/v${VERSION}/dep-linux-amd64 \
 && chmod +x dep \
 && touch meta.data \
 && echo "- [dep](https://github.com/golang/dep).(v${VERSION}," \
    "[diff](https://github.com/golang/dep/v${VERSION}...master))" >> meta.data

CMD /bin/sh
