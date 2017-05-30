FROM alpine:latest

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

COPY ./artifacts/hugo /usr/local/bin/

WORKDIR /usr/share/site

ENV BIND     '0.0.0.0'
ENV PORT     '1313'
ENV BASE_URL 'http://127.0.0.1:${PORT}'
ENV ARGS     ''

EXPOSE ${PORT}

CMD hugo server --bind=${BIND} --port=${PORT} --baseURL=${BASE_URL} ${ARGS}

# TODO
# ONBUILD ADD ... /usr/share/site
# ONBUILD RUN hugo -d /usr/share/public
