#!/bin/sh

echo "normalizing..."
    [ -n "${LE_ENABLED}" ]
    LE_ENABLED=$(($? == 0))

    [ -n "${DEV_ENABLED}" ]
    DEV_ENABLED=$(($? == 0))

    HTTPS_ENABLED=$(($LE_ENABLED == 1 || $DEV_ENABLED == 1))

    echo "environment:"
    echo "  TIME_ZONE:    " $TIME_ZONE
    echo "  LE_ENABLED:   " $LE_ENABLED
    echo "  LE_EMAIL:     " $LE_EMAIL
    echo "  DEV_ENABLED:  " $DEV_ENABLED
    echo "  HTTPS_ENABLED:" $HTTPS_ENABLED
echo "done"

echo "setup timezone..."
    cp /usr/share/zoneinfo/"${TIME_ZONE}" /etc/localtime
    echo "${TIME_ZONE}" > /etc/timezone
echo "done"








cert() {
    #  $0       $1     $2   $3   $4                ${@:5}
    # cert some.domain key cert chain
    # cert some.domain key cert chain www.some.domain alias.some.domain
    domain=$1
    key=$2
    cert=$3
    chain=$4
    aliases=${@:5}

    echo "run certbot for ${domain}..."
    #mkdir -p /usr/share/nginx/html/.well-known/acme-challenge      || return $?
    #certbot certonly -t -n \
    #                 --agree-tos \
    #                 --renew-by-default \
    #                 --email "${LE_EMAIL}" \
    #                 --webroot \
    #                 -w /usr/share/nginx/html \
    #                 -d $domain                                    || return $?
    #cp -fv /etc/letsencrypt/live/$domain/fullchain.pem ${SSL_CERT} || return $?
    #cp -fv /etc/letsencrypt/live/$domain/privkey.pem   ${SSL_KEY}  || return $?
    echo "done"
}

# ./certbot-auto certonly --webroot -w /var/www/html \
#     -d tutorial.serverops.io \
#     --non-interactive --agree-tos --email chris@serversforhackers.com

dhparam() {
    echo "make dhparams..."
    if [ ! -f /etc/nginx/ssl/dhparams.pem ]; then
        (
            cd /etc/nginx/ssl
            openssl dhparam -out dhparams.pem 2048
            if [ ! $? = 0 ]; then
                echo "[CRITICAL] cannot generate Diffie-Hellman parameters"
                return 1
            fi
            chmod 600 dhparams.pem
        )
    else
        echo "skipped"
    fi
    echo "done"
}

generate() {
    echo "generate self-signed certificate..."
    if [ ! -f /etc/nginx/ssl/xip.io.crt -o ! -f /etc/nginx/ssl/xip.io.key ]; then
        (
            cd /etc/nginx/ssl
            openssl req -config local.conf -new -newkey rsa -x509 -days 365 -out xip.io.crt
            if [ ! $? = 0 ]; then
                echo "[CRITICAL] cannot generate self-signed certificate"
                return 1
            fi
        )
    else
        echo "skipped"
    fi
    echo "done"
}

enable_dev() {
    echo "find all configurations with HTTPS comment"
    (
        export WWW_SSL_CERT=/etc/nginx/ssl/xip.io.crt
        export WWW_SSL_KEY=/etc/nginx/ssl/xip.io.key
        export SSL_CERT=/etc/nginx/ssl/xip.io.crt
        export SSL_KEY=/etc/nginx/ssl/xip.io.key

        cd /etc/nginx/conf.d
        for conf in $(grep -lw *.conf -e '#:https '); do
            cp $conf ${conf}.backup
            envsubst '${WWW_SSL_CERT} ${WWW_SSL_KEY} ${SSL_CERT} ${SSL_KEY}' < $conf > ${conf}.tmp
            sed -i "s|#:https ||g" ${conf}.tmp
            sed -i "s|#:www ||g" ${conf}.tmp
            cat ${conf}.tmp > $conf
            nginx -t
            if [ ! $? = 0 ]; then
                cat ${conf}.backup > $conf
                rm ${conf}.backup
                echo "[CRITICAL] configuration /etc/nginx/conf.d/${conf} without HTTPS comments is invalid"
            else
                echo "configuration /etc/nginx/conf.d/${conf} is updated"
            fi
            rm ${conf}.tmp
        done
    )
    echo "done"
}

watch() {
    if [ ! $HTTPS_ENABLED = 1 ]; then
        echo "HTTPS is disabled"
        return 0
    fi
    dhparam || return $?
    if [ ! $LE_ENABLED = 1 ]; then
        echo "[WARNING] let's encrypt is disabled"
        echo "[WARNING] environment will be configured for local development"
        generate   || return $?
        enable_dev || return $?
    else
        echo "TODO let's encrypt"
    fi

    return 0

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
}










watch &
echo "start nginx..."
nginx -g "daemon off;"
