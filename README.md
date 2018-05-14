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

#### Useful

##### Articles

- [ ] [OCSP stapling](https://en.wikipedia.org/wiki/OCSP_stapling)
- [ ] [Security/Server Side TLS](https://wiki.mozilla.org/Security/Server_Side_TLS)
- [ ] [Strong SSL Security on nginx](https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html)

##### Docs

- [ ] [Certbot documentation](https://certbot.eff.org/docs/)
- [ ] [Let's Encrypt documentation](https://letsencrypt.org/docs/)
- [ ] [nginx documentation](http://nginx.org/en/docs/)

##### Lessons

- [ ] [Integrating SSL Certificates](https://serversforhackers.com/s/integrating-ssl-certificates)

---

[![@kamilsk](https://img.shields.io/badge/author-%40kamilsk-blue.svg)](https://twitter.com/ikamilsk)
[![@octolab](https://img.shields.io/badge/sponsor-%40octolab-blue.svg)](https://twitter.com/octolab_inc)

made with ❤️ by [OctoLab](https://www.octolab.org/)
