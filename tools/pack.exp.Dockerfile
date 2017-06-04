FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

COPY artifacts/apicompat/* artifacts/benchcmp/* \
     artifacts/depth artifacts/godepq/* \
     artifacts/goreporter/* artifacts/honnef/* \
     artifacts/zb/* \
     /go/bin/

CMD /bin/sh
