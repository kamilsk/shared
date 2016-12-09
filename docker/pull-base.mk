.PHONY: docker-pull-1.5
docker-pull-1.5:
	docker pull golang:1.5

.PHONY: docker-pull-1.6
docker-pull-1.6:
	docker pull golang:1.6

.PHONY: docker-pull-1.7
docker-pull-1.7:
	docker pull golang:1.7

.PHONY: docker-pull-latest
docker-pull-latest:
	docker pull golang:latest
