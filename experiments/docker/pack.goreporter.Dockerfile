FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

COPY artifacts/goreporter/* /go/bin/

CMD /bin/sh
