## Docker

.PHONY: pull-kylemanna/openvpn
pull-kylemanna/openvpn:
	rm -rf docker/kylemanna/openvpn
	git clone git@github.com:kylemanna/docker-openvpn.git docker/kylemanna/openvpn
	( \
	  cd docker/kylemanna/openvpn && \
	  echo 'kylemanna/openvpn at revision' $$(git rev-parse HEAD) > metadata \
	)
	rm -rf docker/kylemanna/openvpn/.git
