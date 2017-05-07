FROM alpine:latest

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

COPY ./artifacts/hugo /usr/local/bin/

EXPOSE 1313

CMD ["hugo", "server"]
