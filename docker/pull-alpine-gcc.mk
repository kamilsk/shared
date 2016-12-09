.PHONY: docker-pull-1.5-alpine-gcc
docker-pull-1.5-alpine-gcc:
	docker pull kamilsk/golang:1.5-alpine

.PHONY: docker-pull-1.6-alpine-gcc
docker-pull-1.6-alpine-gcc:
	docker pull kamilsk/golang:1.6-alpine

.PHONY: docker-pull-1.7-alpine-gcc
docker-pull-1.7-alpine-gcc:
	docker pull kamilsk/golang:1.7-alpine

.PHONY: docker-pull-alpine-gcc
docker-pull-alpine-gcc:
	docker pull kamilsk/golang:alpine
