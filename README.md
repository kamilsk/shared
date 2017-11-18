> # shared:github-tpl-go-v1
>
> My templates for Go projects at GitHub.

## Integration

```
.PHONY: pull-github-tpl
pull-github-tpl:
	rm -rf .github
	git clone git@github.com:kamilsk/shared.git .github
	( \
	  cd .github && \
	  git checkout github-tpl-go-v1 && \
	  git branch -d master && \
	  echo '- ' $$(cat README.md | head -n1 | awk '{print $$3}') 'at revision' $$(git rev-parse HEAD) \
	)
	rm -rf .github/.git .github/README.md
```

[![Analytics](https://ga-beacon.appspot.com/UA-109817251-4/shared/github-tpl-go-v1:readme)](https://github.com/igrigorik/ga-beacon)
