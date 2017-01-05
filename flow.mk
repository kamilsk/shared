#
# Go package's targets for publishing to open source.
#
# Version: 1.0
#

ifeq ($(or $(GIT_ORIGIN), $(GIT_MIRROR)),)
$(error Please provide GIT_ORIGIN and GIT_MIRROR (e.g. GIT_ORIGIN = git@github.com:kamilsk/semaphore.git))
endif

.PHONY: flow-dev
flow-dev:
	git config user.email 'kamil@samigullin.info'
	git config user.name 'Kamil Samigullin'

	git remote set-url origin $(GIT_ORIGIN)
	git remote -v | grep mirror > /dev/null; if [ $$? != 0 ] ; then git remote add mirror $(GIT_MIRROR) ; fi

.PHONY: flow-publish
flow-publish:
	git push origin master --tags
	git push mirror master --tags
