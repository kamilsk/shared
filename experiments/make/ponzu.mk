
.PHONY: drop-ponzu
drop-ponzu: clean-invalid-experiments
drop-ponzu:
	docker images --all \
	| grep '^kamilsk\/go-experiments\s\+' \
	| awk '{print $$2 "\t" $$3}' \
	| grep 'ponzu' \
	| awk '{print $$2}' \
	| xargs docker rmi -f &>/dev/null || true

.PHONY: publish-ponzu
publish-ponzu:
	@echo 'nothing'

.PHONY: pull-ponzu
pull-ponzu:
	@echo 'nothing'

### [kamilsk/ponzu](https://hub.docker.com/r/kamilsk/ponzu/)
