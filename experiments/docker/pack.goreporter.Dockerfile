FROM golang:alpine

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

COPY artifacts/goreporter/* /go/bin/

CMD /bin/sh
