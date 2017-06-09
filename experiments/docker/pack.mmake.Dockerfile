FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

COPY artifacts/mmake/* /go/bin/

CMD /bin/sh
