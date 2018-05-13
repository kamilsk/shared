.PHONY: pull-umputun/nginx-le
pull-umputun/nginx-le:
	rm -rf docker/umputun/nginx-le
	git clone git@github.com:umputun/nginx-le.git docker/umputun/nginx-le
	( \
	  cd docker/umputun/nginx-le && \
	  echo 'umputun/nginx-le at revision' $$(git rev-parse HEAD) > metadata \
	)
	rm -rf docker/umputun/nginx-le/.git
