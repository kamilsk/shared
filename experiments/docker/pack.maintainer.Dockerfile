FROM golang:alpine

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

COPY artifacts/maintainer/* /go/bin/

CMD /bin/sh
