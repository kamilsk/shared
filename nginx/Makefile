NGINX_ALPINE := $(shell docker images | grep '^nginx\s\+mainline-alpine\s\+' | awk '{print $$3}')
NGINX_DEBIAN := $(shell docker images | grep '^nginx\s\+mainline\s\+' | awk '{print $$3}')

.PHONY: build-nginx-parallel
build-nginx-parallel:
	semaphore create
	semaphore add -- make build-nginx-alpine
	semaphore add -- make build-nginx-debian
	semaphore wait

.PHONY: build-nginx
build-nginx: build-nginx-alpine build-nginx-debian

.PHONY: build-nginx-alpine
build-nginx-alpine:
	docker build -f $(CWD)/nginx/mainline-alpine.Dockerfile \
	             -t kamilsk/nginx:alpine \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$(NGINX_ALPINE) \
	             $(CWD)/nginx

.PHONY: build-nginx-debian
build-nginx-debian:
	docker build -f $(CWD)/nginx/mainline-debian.Dockerfile \
	             -t kamilsk/nginx:debian \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$(NGINX_DEBIAN) \
	             $(CWD)/nginx


.PHONY: clean-invalid-nginx
clean-invalid-nginx:
	docker images --all \
	| grep '^kamilsk\/nginx\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep '^<none>\s\+' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true


.PHONY: drop-nginx
drop-nginx:
	docker images --all \
	| grep '^kamilsk\/nginx\s\+' \
	| awk '{print $$3}' \
	| xargs docker rmi -f &>/dev/null || true


.PHONY: in-nginx-alpine
in-nginx-alpine:
	docker run --rm -it --entrypoint /bin/sh kamilsk/nginx:alpine

.PHONY: in-nginx-debian
in-nginx-debian:
	docker run --rm -it --entrypoint /bin/sh kamilsk/nginx:debian


.PHONY: process-nginx
process-nginx: drop-nginx build-nginx publish-nginx


.PHONY: publish-nginx
publish-nginx: publish-nginx-alpine publish-nginx-debian

.PHONY: publish-nginx-alpine
publish-nginx-alpine:
	docker push kamilsk/nginx:alpine

.PHONY: publish-nginx-debian
publish-nginx-debian:
	docker push kamilsk/nginx:debian


.PHONY: refresh-nginx
refresh-nginx: drop-nginx refresh-nginx-alpine refresh-nginx-debian

.PHONY: refresh-nginx-alpine
refresh-nginx-alpine:
	docker pull kamilsk/nginx:alpine

.PHONY: refresh-nginx-debian
refresh-nginx-debian:
	docker pull kamilsk/nginx:debian


.PHONY: copy-nginx-mainline-alpine
copy-nginx-mainline-alpine:
	rm -rf ./nginx/etc/mainline-alpine/*
	docker run --rm -d --name=nginx-mainline-alpine nginx:mainline-alpine
	docker exec nginx-mainline-alpine rm -rf /etc/nginx/modules
	docker cp nginx-mainline-alpine:/etc/nginx ./nginx/etc/mainline-alpine/
	mv ./nginx/etc/mainline-alpine/nginx/* ./nginx/etc/mainline-alpine/
	rm -rf ./nginx/etc/mainline-alpine/nginx
	docker stop nginx-mainline-alpine
	echo 'nginx:mainline-alpine at revision' $(NGINX_ALPINE) > ./nginx/etc/mainline-alpine/metadata

.PHONY: copy-nginx-mainline
copy-nginx-mainline:
	rm -rf ./nginx/etc/mainline/*
	docker run --rm -d --name=nginx-mainline nginx:mainline
	docker cp nginx-mainline:/etc/nginx ./nginx/etc/mainline/
	mv ./nginx/etc/mainline/nginx/* ./nginx/etc/mainline/
	rm -rf ./nginx/etc/mainline/nginx
	docker stop nginx-mainline
	echo 'nginx:mainline at revision' $(NGINX_DEBIAN) > ./nginx/etc/mainline/metadata
