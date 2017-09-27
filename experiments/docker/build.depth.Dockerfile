FROM golang:alpine

LABEL maintainer="Kamil Samigullin <kamil@samigullin.info>"

ARG BASE
ARG DEPTH

WORKDIR /tmp

RUN apk add --no-cache ca-certificates wget \
 && update-ca-certificates &>/dev/null \

 && wget -q -O depth.bin \
    https://github.com/KyleBanks/depth/releases/download/v${DEPTH}/depth_${DEPTH}_linux_amd64 \
 && mkdir depth && chmod +x depth.bin && mv depth.bin depth/depth \

 && touch meta.data \
 && echo $'\n\
<<< START METADATA\n\
\n\
METADATA:short \n\
golang:alpine with depth \n\
\n\
METADATA:full' >> meta.data \
 && echo "golang:alpine.(${BASE}) with " >> meta.data \

 && echo "- [depth](https://github.com/KyleBanks/depth).(v${DEPTH}," \
    "[diff](https://github.com/KyleBanks/depth/compare/v${DEPTH}...master))" >> meta.data \

 && echo $'\n\
>>> END METADATA' >> meta.data

CMD /bin/sh
