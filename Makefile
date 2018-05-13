.PHONY: pull-umputun/nginx-le
pull-umputun/nginx-le:
	rm -rf docker/umputun/nginx-le
	git clone git@github.com:umputun/nginx-le.git docker/umputun/nginx-le
	( \
	  cd docker/umputun/nginx-le && \
	  echo 'umputun/nginx-le at revision' $$(git rev-parse HEAD) > metadata \
	)
	rm -rf docker/umputun/nginx-le/.git

.PHONY: pull-kylemanna/openvpn
pull-kylemanna/openvpn:
	rm -rf docker/kylemanna/openvpn
	git clone git@github.com:kylemanna/docker-openvpn.git docker/kylemanna/openvpn
	( \
	  cd docker/kylemanna/openvpn && \
	  echo 'kylemanna/openvpn at revision' $$(git rev-parse HEAD) > metadata \
	)
	rm -rf docker/kylemanna/openvpn/.git
