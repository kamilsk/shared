FROM golang:alpine

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

COPY artifacts/easyjson/* \
     artifacts/glide/linux-amd64/glide \
     artifacts/gometalinter/* \
     artifacts/goreleaser/goreleaser \
     artifacts/protobuf/go-protobuf/* \
     artifacts/protobuf/gogo-protobuf/* \
     artifacts/retry/retry \
     artifacts/semaphore/semaphore \
     /go/bin/
COPY artifacts/protobuf/protoc/* /usr/local/bin/

# g++       - protobuf
# gcc       - gometalinter, protobuf
# git       - glide, go get
# libc-dev  - gometalinter
# mercurial - glide, go get
RUN apk add --no-cache g++ gcc git libc-dev mercurial

CMD /bin/sh
