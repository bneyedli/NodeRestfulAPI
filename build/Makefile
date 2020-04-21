SHELL=/usr/bin/env bash

ifndef BUILD_TARGET
 $(error BUILD_TARGET not defined, please export or pass inline)
endif

ifndef DEBUG
export DEBUG=0
endif

GIT_TAG_LAST=$(shell git tag -l | sort -V | tail -n1)

include $(BUILD_TARGET)/project-build.spec
include $(BUILD_TARGET)/test/project-build-test.spec

docker-build:
	@(( $(DEBUG) == 0 )) || echo -e "--\nBuilding docker image: $(BUILD_TARGET)\n\twith args: $(DOCKER_BUILD_ARGS)"
	@docker build -t $(BUILD_TARGET):latest $(DOCKER_BUILD_ARGS) $(BUILD_TARGET)
	@(( $(DEBUG) == 0 )) || echo -e "--\nTagging image with tags: $(DOCKER_TAGS)"
	@[[ -z "$(DOCKER_TAGS)" ]] || ./utils/docker-tagger.sh $(BUILD_TARGET):latest $(DOCKER_TAGS)

build: $(BUILD_TARGET)-build
test: $(BUILD_TARGET)-test
