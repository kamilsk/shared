FROM alpine:latest

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

ARG BASE
ARG VERSION

RUN apk update --no-cache \
 && apk add --no-cache ca-certificates wget \
 && update-ca-certificates &>/dev/null \

 && wget -q -O /tmp/hugo.tar.gz \
    https://github.com/spf13/hugo/releases/download/v${VERSION}/hugo_${VERSION}_Linux-64bit.tar.gz \
 && mkdir /tmp/hugo && tar xf /tmp/hugo.tar.gz -C /tmp/hugo \

 && echo $'\n\
<<< START METADATA\n\
\n\
METADATA:short \n\
alpine:latest with hugo \n\
\n\
METADATA:full' >> /tmp/meta.data \
 && echo "alpine:latest.(${BASE}) with [hugo](http://gohugo.io).(v${VERSION}," \
    "[diff](https://github.com/spf13/hugo/compare/v${VERSION}...master))" \
    >> /tmp/meta.data \
 && echo $'\n\
[Dockerfile](https://github.com/kamilsk/shared/blob/docker-go-v1/hugo) \n\
[Useful Makefile](https://github.com/kamilsk/shared/blob/makefile-go-v1/docker/hugo.mk) \n\
\n\
>>> END METADATA' >> /tmp/meta.data

CMD ["sh"]
