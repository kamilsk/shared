FROM alpine:latest

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

ARG BASE
ARG VERSION

COPY ./artifacts/hugo /usr/local/bin/hugo

RUN echo $'\n\
<<< START METADATA\n\
\n\
METADATA:short \n\
alpine:latest with hugo \n\
\n\
METADATA:full' \
 && echo "alpine:latest.(${BASE}) with hugo.(${VERSION})" \
 && echo $'\n\
[Dockerfile](https://github.com/kamilsk/shared/blob/docker-go-v1/hugo) \n\
[Useful Makefile](https://github.com/kamilsk/shared/blob/makefile-go-v1/docker/hugo.mk) \n\
\n\
>>> END METADATA\n'

EXPOSE 1313

CMD ["hugo", "server"]
