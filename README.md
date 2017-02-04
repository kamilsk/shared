> # shared:docker-go-v1
>
> My custom docker images for Go environment.

## Common

### [kamilsk/golang:1.5-alpine](alpine-gcc/1.5-alpine.Dockerfile)

### [kamilsk/golang:1.6-alpine](alpine-gcc/1.6-alpine.Dockerfile)

### [kamilsk/golang:1.7-alpine](alpine-gcc/1.7-alpine.Dockerfile)

### [kamilsk/golang:1.8-alpine](alpine-gcc/1.8-alpine.Dockerfile)

## Tools

### [kamilsk/hugo:latest](hugo/Dockerfile)

[hugo](https://gohugo.io) v0.18.1

### [kamilsk/go-tools:latest](tools/Dockerfile)

[glide](https://github.com/Masterminds/glide) v0.12.3

[gometalinter](https://github.com/alecthomas/gometalinter) v1.0.3 with
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

[honnef.co/go/tools](https://github.com/dominikh/go-tools)
- [gosimple](https://github.com/dominikh/go-tools/tree/master/cmd/gosimple)
- [keyify](https://github.com/dominikh/go-tools/tree/master/cmd/keyify)
- [rdeps](https://github.com/dominikh/go-tools/tree/master/cmd/rdeps)
- [staticcheck](https://github.com/dominikh/go-tools/tree/master/cmd/staticcheck)
- [structlayout](https://github.com/dominikh/go-tools/tree/master/cmd/structlayout)
- [structlayout-optimize](https://github.com/dominikh/go-tools/tree/master/cmd/structlayout-optimize)
- [structlayout-pretty](https://github.com/dominikh/go-tools/tree/master/cmd/structlayout-pretty)
- [unused](https://github.com/dominikh/go-tools/tree/master/cmd/unused)

```bash
$ git rev-parse --short=7 HEAD
6bc9a2a
```

## Notes

Discovering

```bash
$ docker run -it --rm kamilsk/go-tools:latest /bin/sh
```
