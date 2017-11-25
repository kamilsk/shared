FROM nginx:mainline-alpine

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

ARG BASE

ENV TIME_ZONE  "UTC"
ENV LE_ENABLED ""
ENV LE_EMAIL   "kamil@samigullin.info"

ADD conf/default.conf conf/nginx.conf script/entrypoint.sh metadata /

RUN \
    apk add --no-cache certbot openssl tzdata && \
    mv /etc/nginx/nginx.conf /etc/nginx/nginx.origin && \
    mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.origin && \
    mv /nginx.conf /etc/nginx/ && \
    mv /default.conf /etc/nginx/conf.d/ && \
    chmod +x /entrypoint.sh && \
    sed -i "s/NGINX_BASE/${BASE}/" metadata && \
    sed -i "s/NGINX_VERSION/$(nginx -v 2>&1 | awk '{print $3}' | cut -d'/' -f2)/" metadata && \
    sed -i "s/CERTBOT_VERSION/$(certbot --version 2>&1 | awk '{print $2}')/" metadata && \
    echo "done"

VOLUME [ "/etc/nginx/ssl" ]

ENTRYPOINT [ "/entrypoint.sh" ]
