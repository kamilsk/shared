#!/bin/sh

echo "setup timezone..."
(
    cp /usr/share/zoneinfo/"${TIME_ZONE}" /etc/localtime
    echo "${TIME_ZONE}" > /etc/timezone
)
echo "done"

if [ -z "${LE_ENABLED}" ] && [ ! -f /etc/nginx/ssl/dhparams.pem ]; then
    echo "make dhparams..."
    (
        cd /etc/nginx/ssl
        openssl dhparam -out dhparams.pem 2048
        chmod 600 dhparams.pem
    )
    echo "done"
fi

cert() {
    domain=$1
    aliases=$(echo $2 | sed -e 's/,/ /g')

    echo "run certbot for ${domain}..."
    mkdir -p /usr/share/nginx/html/.well-known/acme-challenge      || return $?
    certbot certonly -t -n \
                     --agree-tos \
                     --renew-by-default \
                     --email "${LE_EMAIL}" \
                     --webroot \
                     -w /usr/share/nginx/html \
                     -d $domain                                    || return $?
    cp -fv /etc/letsencrypt/live/$domain/fullchain.pem ${SSL_CERT} || return $?
    cp -fv /etc/letsencrypt/live/$domain/privkey.pem   ${SSL_KEY}  || return $?
    echo "done"
}

(
    if [ -z "${LE_ENABLED}" ]; then
        echo "let's encrypt is disabled"
        exit 1
    fi

    echo "wait nginx..."
    sleep 2
    echo "ready to while"

    while :
    do
        echo "trying to update let's encrypt..."
        set -x
        # spec is domain:alias1,alias2
        for spec in $@; do
            domain=$(echo  $spec | awk -F ':' '{print $1}')
            aliases=$(echo $spec | awk -F ':' '{print $2}')
            export SSL_CERT=/etc/nginx/ssl/le-${domain}-crt.pem
            export SSL_KEY=/etc/nginx/ssl/le-${domain}-key.pem

            [ ! -f "${SSL_CERT}" ] && not_exists=true || not_exists=false
            ! $not_exists && is_old=$(( (`date +%s` - `stat -c %Y "${SSL_CERT}"`) > (30*24*60*60) )) || is_old=0
            success=false
            if $not_exists || [ $is_old = 1 ]; then
                cert $domain $aliases && success=true
            else
                echo "certificate of ${domain} is actual" && success=true
            fi

            if $success; then
                echo "setup ssl configuration for ${domain}..."
                envsubst '$$SSL_CERT $$SSL_KEY' \
                    < /etc/nginx/conf.d/$domain.conf > /etc/nginx/conf.d/$domain.conf.tmp
                sed -i 's/#:ssl //' /etc/nginx/conf.d/$domain.conf.tmp
                cat /etc/nginx/conf.d/$domain.conf.tmp > /etc/nginx/conf.d/$domain.conf
                rm /etc/nginx/conf.d/$domain.conf.tmp
                echo "done"
            else
                echo "setup ssl configuration for ${domain} is failed"
            fi
        done
        set +x

        nginx -s reload
        sleep 1d
    done
) &

echo "start nginx..."
nginx -g "daemon off;"
