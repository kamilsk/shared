FROM alpine:latest AS build

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

ARG BASE
ARG VERSION

WORKDIR /tmp

RUN apk add --no-cache ca-certificates wget \
 && update-ca-certificates &>/dev/null \

 && wget -q -O hugo.tar.gz \
    https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_${VERSION}_Linux-64bit.tar.gz \
 && tar xf hugo.tar.gz \
 && rm hugo.tar.gz \

 && echo $'\n\
<<< START METADATA\n\
METADATA:short \n\
Alpine Linux with Hugo \n\
\n\
METADATA:full' >> meta.data \
 && echo "Alpine Linux ([alpine](https://hub.docker.com/_/alpine/):latest.${BASE}) with [Hugo](http://gohugo.io).(v${VERSION}," \
    "[diff](https://github.com/gohugoio/hugo/compare/v${VERSION}...master))" >> meta.data \
 && echo $'\n\
[Dockerfile](https://github.com/kamilsk/shared/blob/docker-go-v1/hugo) \n\
[Useful Makefile](https://github.com/kamilsk/shared/blob/makefile-go-v1/docker/hugo.mk) \n\
>>> END METADATA' >> meta.data



FROM alpine:latest

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

COPY --from=build /tmp/hugo /usr/local/bin/
COPY --from=build /tmp/meta.data /usr/share/

ENV BIND     '0.0.0.0'
ENV PORT     '1313'
ENV BASE_URL 'http://127.0.0.1:${PORT}'
ENV ARGS     ''

WORKDIR /usr/share/site

CMD hugo server --bind=${BIND} --port=${PORT} --baseURL=${BASE_URL} ${ARGS}

EXPOSE ${PORT}

ONBUILD COPY . /usr/share/site
ONBUILD RUN hugo -d /usr/share/public
ONBUILD VOLUME /usr/share/public
