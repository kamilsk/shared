FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

COPY artifacts/apicompat/* /go/bin/

CMD /bin/sh
