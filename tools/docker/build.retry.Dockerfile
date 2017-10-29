FROM alpine:latest

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

ARG VERSION

WORKDIR /tmp

RUN apk add --no-cache ca-certificates wget \
 && update-ca-certificates \
 && wget -q -O retry.tar.gz \
    https://github.com/kamilsk/retry/releases/download/${VERSION}/retry_${VERSION}_Linux-64bit.tar.gz \
 && mkdir retry && tar xf retry.tar.gz -C retry/ \
 && rm retry.tar.gz \
 && touch meta.data \
 && echo "- [retry](https://github.com/kamilsk/retry).(${VERSION}," \
    "[diff](https://github.com/kamilsk/retry/compare/${VERSION}...master))" >> meta.data

CMD /bin/sh
