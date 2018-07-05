> # shared:github-tpl-go
> [![Analytics](https://ga-beacon.appspot.com/UA-109817251-4/shared/github-tpl-go:readme?pixel)](https://github.com/kamilsk/shared/tree/github-tpl-go)
> My templates for Go projects at GitHub.

[![Patreon](https://img.shields.io/badge/patreon-donate-orange.svg)](https://www.patreon.com/octolab)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Integration

```
.PHONY: pull-github-tpl
pull-github-tpl:
	rm -rf .github
	git clone git@github.com:kamilsk/shared.git .github
	( \
	  cd .github && \
	  git checkout github-tpl-go && \
	  git branch -d master && \
	  echo '- ' $$(cat README.md | head -n1 | awk '{print $$3}') 'at revision' $$(git rev-parse HEAD) \
	)
	rm -rf .github/.git .github/README.md
```

## Useful

- [Multiple issue and pull request templates](https://blog.github.com/2018-01-25-multiple-issue-and-pull-request-templates/)

---

[![@kamilsk](https://img.shields.io/badge/author-%40kamilsk-blue.svg)](https://twitter.com/ikamilsk)
[![@octolab](https://img.shields.io/badge/sponsor-%40octolab-blue.svg)](https://twitter.com/octolab_inc)

made with ❤️ by [OctoLab](https://www.octolab.org/)
