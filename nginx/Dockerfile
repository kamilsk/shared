FROM nginx:mainline

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

ARG BASE

ENV TIME_ZONE  "UTC"
ENV LE_ENABLED ""
ENV LE_EMAIL   "kamil@samigullin.info"
ENV LE_DOMAINS ""

ADD conf/default.conf script/entrypoint.sh metadata conf/nginx.conf /

RUN \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install certbot -y && \
    apt-get clean -y && \
    mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.origin && \
    mv /default.conf /etc/nginx/conf.d/ && \
    chmod +x /entrypoint.sh && \
    sed -i "s/NGINX_MAINLINE/${BASE}/" metadata && \
    sed -i "s/NGINX_VERSION/$(nginx -v 2>&1 | awk '{print $3}' | cut -d'/' -f2)/" metadata && \
    sed -i "s/CERTBOT_VERSION/$(certbot --version 2>&1 | awk '{print $2}')/" metadata && \
    mv /etc/nginx/nginx.conf /etc/nginx/nginx.origin && \
    mv /nginx.conf /etc/nginx/ && \
    mkdir /etc/nginx/ssl

CMD ["/entrypoint.sh"]
