MAKEPATH := $(abspath $(firstword $(MAKEFILE_LIST)))
PWD      := $(patsubst %/,%,$(dir $(MAKEPATH)))

.PHONY: build-tools
build-tools:
	docker build -t kamilsk/php-tools:latest \
	             -f $(PWD)/tools/Dockerfile \
	             $(PWD)/tools



.PHONY: clean-invalid
clean-invalid:
	docker images --all \
	| grep '^<none>\s\+' \
	| awk '{print $$3}' \
	| xargs docker rmi -f "$$1"



.PHONY: drop-tools
drop-tools:
	docker images --all \
	| grep '^kamilsk\/php-tools\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep -v '^<none>\s\+' \
	| awk '{print $$2}' \
	| xargs docker rmi -f "$$1"



.PHONY: publish-tools
publish-tools:
	docker push kamilsk/php-tools:latest
