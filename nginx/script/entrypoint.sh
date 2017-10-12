#!/bin/sh

echo "setup timezone"
cp /usr/share/zoneinfo/"${TIME_ZONE}" /etc/localtime && echo "${TIME_ZONE}" > /etc/timezone

if [ ! -f /etc/nginx/ssl/dhparams.pem ]; then
    echo "make dhparams"
    (
        cd /etc/nginx/ssl
        openssl dhparam -out dhparams.pem 2048
        chmod 600 dhparams.pem
    )
fi

(
    if [ -z "${LE_ENABLED}" ]; then
        echo "let's encrypt is disabled"
        exit 1
    fi
    echo "wait nginx"
    sleep 5
    while :
    do
        echo "trying to update let's encrypt..."
        set -x
        for domain in $(echo $LE_DOMAINS | tr ',' ' '); do
            echo "run certbot for ${domain}"
            mkdir -p /usr/share/sites/$domain/.well-known/acme-challenge
            certbot certonly -t -n \
                --agree-tos \
                --renew-by-default \
                --email "${LE_EMAIL}" \
                --webroot \
                -w /usr/share/sites/$domain \
                -d $domain
            echo "setup ssl"
            export SSL_CERT="/etc/nginx/ssl/le-${domain}-crt.pem"
            export SSL_KEY="/etc/nginx/ssl/le-${domain}-key.pem"
            cp -fv /etc/letsencrypt/live/$domain/fullchain.pem ${SSL_CERT}
            cp -fv /etc/letsencrypt/live/$domain/privkey.pem   ${SSL_KEY}
            cat /etc/nginx/conf.d/$domain.conf | \
                sed "s/# listen 443/listen 443/" | \
                sed "s/# ssl_/ssl_/" | \
                sed "s|SSL_CERT|${SSL_CERT}|" | \
                sed "s|SSL_KEY|${SSL_KEY}|" > /etc/nginx/conf.d/$domain.conf.buffer
            cat /etc/nginx/conf.d/$domain.conf.buffer > /etc/nginx/conf.d/$domain.conf
            rm /etc/nginx/conf.d/$domain.conf.buffer
            echo "done"
        done
        set +x

        nginx -s reload
        sleep 60d
    done
) &

echo "start nginx"
nginx -g "daemon off;"
