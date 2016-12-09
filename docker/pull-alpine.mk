.PHONY: docker-pull-1.5-alpine
docker-pull-1.5-alpine:
	docker pull golang:1.5-alpine

.PHONY: docker-pull-1.6-alpine
docker-pull-1.6-alpine:
	docker pull golang:1.6-alpine

.PHONY: docker-pull-1.7-alpine
docker-pull-1.7-alpine:
	docker pull golang:1.7-alpine

.PHONY: docker-pull-alpine
docker-pull-alpine:
	docker pull golang:alpine
