> # shared:docker-common
> [![Analytics](https://ga-beacon.appspot.com/UA-109817251-4/shared/docker-common:readme?pixel)](https://github.com/kamilsk/shared/tree/docker-common)
> My custom docker images for common usage.

[![Patreon](https://img.shields.io/badge/patreon-donate-orange.svg)](https://www.patreon.com/octolab)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Images

### [kamilsk/nginx](https://hub.docker.com/r/kamilsk/nginx/)

```bash
$ docker run --rm -d \
             -e LE_ENABLED=true -e LE_EMAIL=kamil@samigullin.info \
             -v certificates:/etc/nginx/ssl \
             kamilsk/nginx:alpine kamil.samigullin.info:samigullin.info,www.samigullin.info \
                                  www.octolab.org:octolab.org
```

#### Based on research

- [umputun/nginx-le](https://github.com/kamilsk/shared/tree/research#umputunnginx-le)
- [h5bp/server-configs-nginx](https://github.com/kamilsk/shared/tree/research#h5bpserver-configs-nginx)

#### Development

You can add [self-signed](nginx/etc/ssl/xip.io.crt) certificate to your keychain to avoid getting annoying browser privacy
errors on local development.

```bash
$ make nginx-up nginx-status

       Name                 Command          State                    Ports
---------------------------------------------------------------------------------------------
experiments_nginx_1   nginx -g daemon off;   Up      80/tcp
experiments_proxy_1   /entrypoint.sh         Up      0.0.0.0:443->443/tcp, 0.0.0.0:80->80/tcp

$ open https://127.0.0.1.xip.io/
$ curl -v http://127.0.0.1.xip.io/
# > GET / HTTP/1.1
# > Host: 127.0.0.1.xip.io
# > User-Agent: curl/7.54.0
# > Accept: */*
# >
# < HTTP/1.1 308 Permanent Redirect
# < Server: nginx
# < Date: Tue, 15 May 2018 14:01:52 GMT
# < Content-Type: text/html; charset=utf-8
# < Content-Length: 180
# < Connection: keep-alive
# < Location: https://127.0.0.1.xip.io/
# < Strict-Transport-Security: max-age=86400
# < X-UA-Compatible: IE=Edge
# < X-Frame-Options: SAMEORIGIN
# < X-Content-Type-Options: nosniff
# < X-XSS-Protection: 1; mode=block
# < Cache-Control: no-transform
# <
$ curl -v --insecure https://www.127.0.0.1.xip.io/
# > GET / HTTP/2
# > Host: www.127.0.0.1.xip.io
# > User-Agent: curl/7.54.0
# > Accept: */*
# >
# < HTTP/2 308
# < server: nginx
# < date: Wed, 16 May 2018 08:24:03 GMT
# < content-type: text/html; charset=utf-8
# < content-length: 180
# < location: https://127.0.0.1.xip.io/
# < strict-transport-security: max-age=86400
# <
$ make nginx-down
```

#### Useful

##### Articles

- [x] [How To Set Up HTTPS Locally Without Getting Annoying Browser Privacy Errors](https://deliciousbrains.com/https-locally-without-browser-privacy-errors/)
- [ ] [OCSP stapling](https://en.wikipedia.org/wiki/OCSP_stapling)
- [ ] [Security/Server Side TLS](https://wiki.mozilla.org/Security/Server_Side_TLS)
- [ ] [Strong SSL Security on nginx](https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html)

##### Docs

- [ ] [Certbot documentation](https://certbot.eff.org/docs/)
- [ ] [Let's Encrypt documentation](https://letsencrypt.org/docs/)
- [ ] [nginx documentation](http://nginx.org/en/docs/)
- [ ] [OpenSSL Documentation](https://www.openssl.org/docs/)

##### Lessons

- [x] [Integrating SSL Certificates](https://serversforhackers.com/s/integrating-ssl-certificates)
- [x] [Load Balancing with Nginx](https://serversforhackers.com/s/load-balancing-with-nginx)

### Useful

#### Articles

- [ ] [Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

---

[![@kamilsk](https://img.shields.io/badge/author-%40kamilsk-blue.svg)](https://twitter.com/ikamilsk)
[![@octolab](https://img.shields.io/badge/sponsor-%40octolab-blue.svg)](https://twitter.com/octolab_inc)

made with ❤️ by [OctoLab](https://www.octolab.org/)
