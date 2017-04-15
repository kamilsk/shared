FROM alpine:latest

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

ENV VERSION 0.20

RUN apk update --no-cache \
 && apk add --no-cache ca-certificates wget \
 && update-ca-certificates &>/dev/null \
 && wget -q -O /tmp/hugo.tar.gz https://github.com/spf13/hugo/releases/download/v${VERSION}/hugo_${VERSION}_Linux-64bit.tar.gz \
 && tar xf /tmp/hugo.tar.gz -C /tmp \
 && cp /tmp/hugo_${VERSION}_linux_amd64/hugo_${VERSION}_linux_amd64 /usr/local/bin/hugo \
 && rm -rf /tmp/* \
 && echo "METADATA \\ alpine:latest with wget and hugo version ${VERSION}"

EXPOSE 1313

CMD ["hugo", "server"]
