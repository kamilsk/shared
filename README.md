> # shared:docker-go-v1
>
> My custom docker images for Go environment.

## Common

### [kamilsk/golang:1.5-alpine](1.5-alpine.Dockerfile)

### [kamilsk/golang:1.6-alpine](1.6-alpine.Dockerfile)

### [kamilsk/golang:1.7-alpine](1.7-alpine.Dockerfile)

## Tooling

### [kamilsk/go-tools:alpine](tools.Dockerfile)

#### What's inside

[gometalinter.v1](https://github.com/alecthomas/gometalinter) with
- [structcheck](https://github.com/opennota/check)
- [deadcode](https://github.com/tsenart/deadcode)
- [interfacer](https://github.com/mvdan/interfacer)
- [lll](https://github.com/walle/lll)
- [errcheck](https://github.com/kisielk/errcheck)
- [unused](https://github.com/dominikh/go-unused)
- [gosimple](https://github.com/dominikh/go-simple)
- [ineffassign](https://github.com/gordonklaus/ineffassign)
- [staticcheck](https://github.com/dominikh/go-staticcheck)
- [varcheck](https://github.com/opennota/check)
- [gas](https://github.com/GoASTScanner/gas)
- [gocyclo](https://github.com/alecthomas/gocyclo)
- [golint](https://github.com/golang/lint)
- [goimports](https://godoc.org/golang.org/x/tools/cmd/goimports)
- [gotype](https://godoc.org/golang.org/x/tools/cmd/gotype)
- [misspell](https://github.com/client9/misspell)
- [unconvert](https://github.com/mdempsky/unconvert)
- [aligncheck](https://github.com/opennota/check)
- [dupl](https://github.com/mibk/dupl)
- [goconst](https://github.com/jgautheron/goconst)

## Notes

Discovering

```bash
$ docker run -it --rm kamilsk/go-tools:alpine /bin/sh
```
