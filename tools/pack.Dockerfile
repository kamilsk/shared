FROM golang:alpine

MAINTAINER Kamil Samigullin <kamil@samigullin.info>

COPY artifacts/easyjson/* artifacts/glide/linux-amd64/glide \
     artifacts/gometalinter/* artifacts/goreleaser/goreleaser \
     artifacts/retry/retry \
     /go/bin/

# gcc       - gometalinter
# git       - glide, go get
# libc-dev  - gometalinter
# mercurial - glide, go get
RUN apk add --no-cache gcc git libc-dev mercurial

CMD /bin/sh
