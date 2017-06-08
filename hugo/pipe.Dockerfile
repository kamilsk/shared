FROM alpine:latest build

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

ARG BASE
ARG VERSION

WORKDIR /tmp

RUN apk add --no-cache ca-certificates wget \
 && update-ca-certificates &>/dev/null \

 && wget -q -O hugo.tar.gz \
    https://github.com/spf13/hugo/releases/download/v${VERSION}/hugo_${VERSION}_Linux-64bit.tar.gz \
 && tar xf hugo.tar.gz \
 && rm hugo.tar.gz \

 && echo $'\n\
<<< START METADATA\n\
\n\
METADATA:short \n\
alpine:latest with hugo \n\
\n\
METADATA:full' >> meta.data \
 && echo "alpine:latest.(${BASE}) with [hugo](http://gohugo.io).(v${VERSION}," \
    "[diff](https://github.com/spf13/hugo/compare/v${VERSION}...master))" >> meta.data \
 && echo $'\n\
[Dockerfile](https://github.com/kamilsk/shared/blob/docker-go-v1/hugo) \n\
[Useful Makefile](https://github.com/kamilsk/shared/blob/makefile-go-v1/docker/hugo.mk) \n\
\n\
>>> END METADATA' >> meta.data

CMD /bin/sh



FROM alpine:latest

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

COPY --from=build /tmp/hugo /usr/local/bin/

ENV BIND     '0.0.0.0'
ENV PORT     '1313'
ENV BASE_URL 'http://127.0.0.1:${PORT}'
ENV ARGS     ''

WORKDIR /usr/share/site

CMD hugo server --bind=${BIND} --port=${PORT} --baseURL=${BASE_URL} ${ARGS}

EXPOSE ${PORT}

ONBUILD RUN hugo -d /usr/share/public
