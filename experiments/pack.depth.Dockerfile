FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

COPY artifacts/depth/* /go/bin/

CMD /bin/sh
