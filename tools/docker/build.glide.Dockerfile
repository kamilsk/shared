FROM alpine:latest

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

ARG VERSION

WORKDIR /tmp

RUN apk add --no-cache ca-certificates wget \
 && update-ca-certificates &>/dev/null \
 && wget -q -O glide.tar.gz \
    https://github.com/Masterminds/glide/releases/download/v${VERSION}/glide-v${VERSION}-linux-amd64.tar.gz \
 && mkdir glide && tar xf glide.tar.gz -C glide/ \
 && rm glide.tar.gz \
 && touch meta.data \
 && echo "- [glide](https://glide.sh).(v${VERSION}," \
    "[diff](https://github.com/Masterminds/glide/compare/v${VERSION}...master))" >> meta.data

CMD /bin/sh
