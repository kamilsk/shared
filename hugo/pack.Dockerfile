FROM alpine:latest

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

COPY artifacts/hugo /usr/local/bin/
COPY artifacts/meta.data /usr/share/

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
