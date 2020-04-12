.EXPORT_ALL_VARIABLES:

RUN_CFHL=docker-compose run --rm -v $$PWD:/src -w /src -u 0 cfhl
RUN_AWSCLI=docker-compose run --rm -v $$PWD:/src -w /src -u 0 awscli
CFHL_DOCKER_TAG ?= latest

all: clean build test

clean:
	docker-compose down
.PHONY: clean

_build:
	gem install netaddr -v 1.5.1
	cfhighlander cfcompile bbb

build:
	$(RUN_CFHL) make _build
.PHONY: clean