FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

COPY artifacts/honnef/* /go/bin/

CMD /bin/sh
