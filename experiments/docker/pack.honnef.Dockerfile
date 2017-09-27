FROM golang:alpine

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

COPY artifacts/honnef/* /go/bin/

CMD /bin/sh
