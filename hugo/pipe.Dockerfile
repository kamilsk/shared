FROM alpine:latest AS build

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

ARG BASE
ARG VERSION

WORKDIR /tmp

RUN apk update --no-cache \
 && apk add --no-cache ca-certificates wget \
 && update-ca-certificates &>/dev/null \

 && wget -q -O hugo.tar.gz \
    https://github.com/spf13/hugo/releases/download/v${VERSION}/hugo_${VERSION}_Linux-64bit.tar.gz \
 && mkdir hugo && tar xf hugo.tar.gz -C hugo \

 && echo $'\n\
<<< START METADATA\n\
\n\
METADATA:short \n\
alpine:latest with hugo \n\
\n\
METADATA:full' >> meta.data \
 && echo "alpine:latest.(${BASE}) with [hugo](http://gohugo.io).(v${VERSION}," \
    "[diff](https://github.com/spf13/hugo/compare/v${VERSION}...master))" \
    >> meta.data \
 && echo $'\n\
[Dockerfile](https://github.com/kamilsk/shared/blob/docker-go-v1/hugo) \n\
[Useful Makefile](https://github.com/kamilsk/shared/blob/makefile-go-v1/docker/hugo.mk) \n\
\n\
>>> END METADATA' >> meta.data



FROM alpine:latest

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

COPY --from=build /tmp/hugo/hugo /usr/local/bin/

ENV BIND     '0.0.0.0'
ENV PORT     '1313'
ENV BASE_URL 'http://localhost:8080'
ENV ARGS     ''

EXPOSE ${PORT}

CMD hugo server --bind=${BIND} --port=${PORT} --baseURL=${BASE_URL} ${ARGS}
