FROM alpine:latest

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

COPY ./artifacts/hugo /usr/local/bin/

ENV BIND     '0.0.0.0'
ENV PORT     '1313'
ENV BASE_URL 'http://localhost:8080'
ENV ARGS     ''

EXPOSE ${PORT}

CMD hugo server --bind=${BIND} --port=${PORT} --baseURL=${BASE_URL} ${ARGS}
