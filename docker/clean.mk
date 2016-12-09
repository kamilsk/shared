.PHONY: docker-clean
docker-clean:
	$(eval bad_images = $(shell docker images --all \
                                | grep "^golang\s\+" \
                                | awk '{print $2 "\t" $3}' \
                                | grep "^<none>\s\+" \
                                | awk "{print $2}"))
	@echo $(bad_images)
	$(eval bad_images = $(shell docker images --all \
                                | grep "^kamilsk\/golang\s\+" \
                                | awk '{print $2 "\t" $3}' \
                                | grep "^<none>\s\+" \
                                | awk "{print $2}"))
	@echo $(bad_images)
