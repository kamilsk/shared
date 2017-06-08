FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

COPY artifacts/zb/* /go/bin/

CMD /bin/sh
