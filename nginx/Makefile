NGINX_MAINLINE := $(shell docker images | grep '^nginx\s\+mainline' | awk '{print $$3}')
NGINX_VERSION  ?= latest

.PHONY: build-nginx
build-nginx:
	docker build -f $(CWD)/nginx/Dockerfile \
	             -t kamilsk/nginx:$(NGINX_VERSION) \
	             --force-rm --no-cache --pull --rm \
	             --build-arg BASE=$(NGINX_MAINLINE) \
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

.PHONY: in-nginx
in-nginx:
	docker run --rm -it -e LE_ENABLED=true -e LE_DOMAINS=default kamilsk/nginx:$(NGINX_VERSION) /bin/sh

.PHONY: process-nginx
process-nginx: drop-nginx build-nginx publish-nginx

.PHONY: publish-nginx
publish-nginx:
	docker push kamilsk/nginx:$(NGINX_VERSION)
