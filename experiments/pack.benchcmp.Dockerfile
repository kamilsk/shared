FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

COPY artifacts/benchcmp/* /go/bin/

CMD /bin/sh
