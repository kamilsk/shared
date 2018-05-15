FROM nginx:mainline-alpine

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

ARG BASE

ENV TIME_ZONE  "UTC"
ENV LE_ENABLED ""
ENV LE_EMAIL   ""

ADD etc entrypoint.sh metadata /tmp/

RUN \
    apk add --no-cache certbot openssl tzdata && \
    mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.default && \
    mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.default && \
    mv /tmp/h5bp /etc/nginx/h5bp && \
    mv /tmp/conf.d/default.conf /etc/nginx/conf.d/ && \
    mv /tmp/nginx.conf /etc/nginx/ && \
    mv /tmp/entrypoint.sh / && chmod +x /entrypoint.sh && \
    mv /tmp/metadata / && \
    sed -i "s/NGINX_BASE/${BASE}/" /metadata && \
    sed -i "s/NGINX_VERSION/$(nginx -v 2>&1 | awk '{print $3}' | cut -d'/' -f2)/" /metadata && \
    sed -i "s/CERTBOT_VERSION/$(certbot --version 2>&1 | awk '{print $2}')/" /metadata && \
    rm -rf /tmp/* /var/cache/apk/*

VOLUME [ "/etc/nginx/ssl" ]

ENTRYPOINT [ "/entrypoint.sh" ]
