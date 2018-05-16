#!/usr/bin/env bash

echo "script:" $0 "call stack:" $@

SSL_PATH=/etc/nginx/ssl
DHPARAMS=dhparams.pem
DEV_CERT=xip.io.crt
DEV_KEY=xip.io.key
WEBROOT=/usr/share/nginx/html

echo "normalizing..."
    [ -n "${LE_ENABLED}" -a -n "${LE_EMAIL}" ]
    LE_ENABLED=$(($? == 0))

    [ -n "${DEV_ENABLED}" ]
    DEV_ENABLED=$(($? == 0))

    HTTPS_ENABLED=$(($LE_ENABLED == 1 || $DEV_ENABLED == 1))

    echo "  environment:"
    echo "    TIME_ZONE:    " $TIME_ZONE
    echo "    LE_ENABLED:   " $LE_ENABLED
    echo "    LE_EMAIL:     " $LE_EMAIL
    echo "    DEV_ENABLED:  " $DEV_ENABLED
    echo "    HTTPS_ENABLED:" $HTTPS_ENABLED
    echo ""
    echo "    SSL_PATH:     " $SSL_PATH
    echo "    DHPARAMS:     " ${SSL_PATH}/${DHPARAMS}
    echo "    DEV_CERT:     " ${SSL_PATH}/${DEV_CERT}
    echo "    DEV_KEY:      " ${SSL_PATH}/${DEV_KEY}
echo "done"

echo "setup timezone..."
    cp /usr/share/zoneinfo/"${TIME_ZONE}" /etc/localtime
    echo "${TIME_ZONE}" > /etc/timezone
echo "done"

cert() {
    #     $1      $2      $3       $4               ${@:5}
    # some.domain key certificate chain
    # some.domain key certificate chain www.some.domain alias.some.domain
    local fqdn=$1
    local key=$2
    local certificate=$3
    local chain=$4
    local aliases=${@:5}
    local domain="-d ${fqdn}"
    for alias in ${aliases[@]}; do
        domain="${domain} -d ${alias}"
    done
    if [ $DEV_ENABLED = 1 ]; then
        domain="${domain} --test-cert --dry-run"
    fi
    if [ ${#aliases[@]} = 0 ]; then
        echo "run certbot for ${fqdn}..."
    else
        echo "run certbot for ${fqdn} with aliases ${aliases[@]}..."
    fi
    echo "  expected key:              " $key
    echo "  expected certificate:      " $certificate
    echo "  expected certificate chain:" $chain
    mkdir -p ${WEBROOT}/.well-known/acme-challenge
    set -x
    certbot certonly -t -n \
                     --agree-tos \
                     --renew-by-default \
                     --email "${LE_EMAIL}" \
                     --webroot \
                     -w /usr/share/nginx/html \
                     $domain
    local result=$?
    set +x
    if [ ! $result = 0 ]; then return $result; fi
    cp -fv /etc/letsencrypt/live/${domain}/privkey.pem   ${key}         || return $?
    cp -fv /etc/letsencrypt/live/${domain}/fullchain.pem ${certificate} || return $?
    cp -fv /etc/letsencrypt/live/${domain}/chain.pem     ${chain}       || return $?
    echo "done"
}

dhparam() {
    echo "make dhparams..."
    if [ ! -f ${SSL_PATH}/${DHPARAMS} ]; then
        (
            cd $SSL_PATH
            openssl dhparam -out $DHPARAMS 2048
            if [ ! $? = 0 ]; then
                echo "  [CRITICAL] cannot generate Diffie-Hellman parameters"
                echo "done"
                return 1
            fi
            chmod 600 $DHPARAMS
        )
    else
        echo "  skipped"
    fi
    echo "done"
}

generate() {
    echo "generate self-signed certificate..."
    if [ ! -f ${SSL_PATH}/${DEV_CERT} -o ! -f ${SSL_PATH}/${DEV_KEY} ]; then
        (
            cd $SSL_PATH
            openssl req -out $DEV_CERT -new -newkey rsa -keyout $DEV_KEY -config local.conf -x509 -days 365
            if [ ! $? = 0 ]; then
                echo "  [CRITICAL] cannot generate self-signed certificate"
                echo "done"
                return 1
            fi
            chmod 600 $DEV_CERT $DEV_KEY
        )
    else
        echo "  skipped"
    fi
    echo "done"
}

enable_dev() {
    echo "find all configurations with HTTPS comment..."
    (
        export SSL_CERT=${SSL_PATH}/${DEV_CERT}
        export SSL_KEY=${SSL_PATH}/${DEV_KEY}

        local config_path=/etc/nginx/conf.d
        local sites_path=/etc/nginx/sites-available

        cd $sites_path
        for site in $(grep -l * -e '#:https '); do
            local file=$(basename $site .conf)
            local conf=${config_path}/${file}.conf
            envsubst '${SSL_CERT} ${SSL_KEY}' < $site > $conf
            sed -i "s|#:https ||g" $conf
            sed -i "s|#:dev ||g" $conf
            nginx -t
            if [ ! $? = 0 ]; then
                rm -f $conf
                echo "  [CRITICAL] configuration ${sites_path}/${site} without HTTPS and DEV comments is invalid"
            else
                echo "  configuration ${conf} is ported"
            fi
        done
    )
    echo "done"
}

enable_prod() {
    echo "TODO enable prod..."
}

process() {
    #      ${@:1}
    # specifications...
    #   where specification is domain:alias,...
    if [ ! $HTTPS_ENABLED = 1 ]; then
        echo "  HTTPS is disabled"
        return 0
    fi
    dhparam || return $?
    if [ ! $LE_ENABLED = 1 ]; then
        echo "  [WARNING] let's encrypt is disabled"
        echo "  [WARNING] environment will be configured for local development"
        generate   || return $?
        enable_dev || return $?
    else
        for spec in $@; do
            local fqdn=$(echo $spec | cut -f 1 -d ':')
            local key=${SSL_PATH}/${fqdn}_le-key.pem
            local crt=${SSL_PATH}/${fqdn}_le-crt.pem
            local chn=${SSL_PATH}/${fqdn}_le-chain-crt.pem
            local aliases=$(echo $spec | cut -f 2 -d ':' | tr ',' ' ')
            cert $fqdn $key $crt $chn ${aliases[@]}
            if [ ! $? = 0 ]; then
                echo "  [CRITICAL] cannot process ${fqdn} certificate"
            else
                enable_prod $fqdn $key $crt $chn
                if [ ! $? = 0 ]; then
                    echo "  [CRITICAL] cannot set up configuration for ${fqdn}"
                fi
            fi
        done
    fi
    nginx -s reload
    local result=$?
    if [ ! $result = 0 ]; then
        echo "  [CRITICAL] cannot reload nginx"
    fi
    return $result
}

wrapped_process() {
    echo "start process..."
    process $@
    local result=$?
    echo "done"
    return $result
}

watch() {
    echo "TODO watching..."
}

case $1 in
    process)
        wrapped_process ${@:2}
        ;;
    *)
        (wrapped_process $@ && watch) &
        echo "start nginx..."
        nginx -g "daemon off;"
        ;;
esac
