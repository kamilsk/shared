FROM golang:alpine

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

COPY artifacts/benchcmp/* /go/bin/

CMD /bin/sh
