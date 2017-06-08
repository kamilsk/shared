FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

COPY artifacts/godepq/* /go/bin/

CMD /bin/sh
