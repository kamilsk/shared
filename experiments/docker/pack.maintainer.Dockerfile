FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

COPY artifacts/maintainer/* /go/bin/

CMD /bin/sh
