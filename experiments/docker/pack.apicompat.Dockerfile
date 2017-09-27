FROM golang:alpine

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

COPY artifacts/apicompat/* /go/bin/

CMD /bin/sh
