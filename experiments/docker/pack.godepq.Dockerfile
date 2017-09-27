FROM golang:alpine

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

COPY artifacts/godepq/* /go/bin/

CMD /bin/sh
