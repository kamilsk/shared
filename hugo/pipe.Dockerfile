FROM alpine:latest AS build

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

ARG VERSION

RUN apk update --no-cache \
 && apk add --no-cache ca-certificates wget \
 && update-ca-certificates &>/dev/null \
 && wget -q -O /tmp/hugo.tar.gz \
      https://github.com/spf13/hugo/releases/download/v${VERSION}/hugo_${VERSION}_Linux-64bit.tar.gz \
 && tar xf /tmp/hugo.tar.gz -C /tmp



FROM alpine:latest

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

ARG BASE
ARG VERSION

COPY --from=build /tmp/hugo /usr/local/bin/hugo

RUN echo $'\n\
<<< START METADATA\n\
\n\
METADATA:short \n\
alpine:latest with hugo \n\
\n\
METADATA:full' \
 && echo "alpine:latest.(${BASE}) with hugo.(${VERSION})" \
 && echo $'\n\
[Dockerfile](https://github.com/kamilsk/shared/blob/docker-go-v1/hugo).\n\
[Useful Makefile](https://github.com/kamilsk/shared/blob/makefile-go-v1/docker/hugo.mk).\n\
\n\
>>> END METADATA\n'

EXPOSE 1313

CMD ["hugo", "server"]
