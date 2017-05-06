FROM alpine:latest

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

ARG VERSION

RUN apk update --no-cache \
 && apk add --no-cache ca-certificates wget \
 && update-ca-certificates &>/dev/null \
 && wget -q -O /tmp/hugo.tar.gz \
      https://github.com/spf13/hugo/releases/download/v${VERSION}/hugo_${VERSION}_Linux-64bit.tar.gz \
 && tar xf /tmp/hugo.tar.gz -C /tmp

CMD ["sh"]
