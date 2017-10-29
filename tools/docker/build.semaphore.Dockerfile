FROM alpine:latest

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

ARG VERSION

WORKDIR /tmp

RUN apk add --no-cache ca-certificates wget \
 && update-ca-certificates \
 && wget -q -O semaphore.tar.gz \
    https://github.com/kamilsk/semaphore/releases/download/${VERSION}/semaphore_${VERSION}_Linux-64bit.tar.gz \
 && mkdir semaphore && tar xf semaphore.tar.gz -C semaphore/ \
 && rm semaphore.tar.gz \
 && touch meta.data \
 && echo "- [semaphore](https://github.com/kamilsk/semaphore).(${VERSION}," \
    "[diff](https://github.com/kamilsk/semaphore/compare/${VERSION}...master))" >> meta.data

CMD /bin/sh
