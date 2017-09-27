FROM golang:alpine

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

COPY artifacts/mmake/* /go/bin/

CMD /bin/sh
