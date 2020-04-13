.EXPORT_ALL_VARIABLES:

RUN_CFHL=docker-compose run --rm -v $$PWD:/src -w /src -u 0 cfhl
RUN_AWSCLI=docker-compose run --rm -v $$PWD:/src -w /src -u 0 awscli
CFHL_DOCKER_TAG ?= latest
TEMPLATES_DIST_VERSION ?= $(shell git rev-parse --short HEAD)

DIST_BUCKET ?=
DIST_PREFIX ?=
DIST_VERSION ?= latest
AWS_REGION ?= ap-southeast-2
AWS_DEFAULT_REGION ?= ap-southeast-2

all: clean build test

clean:
	docker-compose down
	rm -rf out
.PHONY: clean

_build:
	gem install netaddr -v 2.0.4
	cfhighlander cfcompile bbb --validate

_publish:
	gem install netaddr -v 2.0.4
	echo $(AWS_DEFAULT_REGION)
	echo $(AWS_REGION)
	cfhighlander cfpublish bbb --validate --dstbucket $(DIST_BUCKET) --dstprefix $(DIST_PREFIX) --version $(DIST_VERSION)

_release:
	gem install netaddr -v 2.0.4
	scripts/release_all.rb

build:
	$(RUN_CFHL) make _build
.PHONY: build

publish:
	$(RUN_CFHL) make _publish
.PHONY: publish

release:
	$(RUN_CFHL) make _release
.PHONY: release
