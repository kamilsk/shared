.PHONY: mount-pkgs
mount-pkgs:
	docker run --rm -it \
	           -v $(PWD)/pkgs:/go/src/pkgs \
	           -w /go/src/pkgs \
	           kamilsk/go-tools:latest
