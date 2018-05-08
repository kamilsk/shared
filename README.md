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

Inspired by [umputun/nginx-le](https://hub.docker.com/r/umputun/nginx-le/).

#### Useful

- [ ] [Let's Encrypt documentation](https://letsencrypt.org/docs/)
- [ ] [Certbot documentation](https://certbot.eff.org/docs/)

---

[![@kamilsk](https://img.shields.io/badge/author-%40kamilsk-blue.svg)](https://twitter.com/ikamilsk)
[![@octolab](https://img.shields.io/badge/sponsor-%40octolab-blue.svg)](https://twitter.com/octolab_inc)

made with ❤️ by [OctoLab](https://www.octolab.org/)
