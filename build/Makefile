SHELL=/usr/bin/env bash
AWS_ACCOUNT_ID=$(shell aws sts get-caller-identity | jq -r .Account)
AWS_REGION=us-east-1
AWS_CLI_ARGS=--region $(AWS_REGION) --output json
AWS_ECR_HOST=$(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com

ifndef BUILD_TARGET
 $(error BUILD_TARGET not defined, please export or pass inline)
endif

ifndef DEBUG
export DEBUG=0
endif

GIT_TAG_LAST=$(shell git tag -l | sort -V | tail -n1)

include $(BUILD_TARGET)/project-build.spec
include $(BUILD_TARGET)/test/project-build-test.spec

build-docker:
	@(( $(DEBUG) == 0 )) || echo -e "--\nBuilding docker image: $(BUILD_TARGET)\n\twith args: $(DOCKER_BUILD_ARGS)"
	@docker build -t $(BUILD_TARGET):latest $(DOCKER_BUILD_ARGS) $(BUILD_TARGET)
	@(( $(DEBUG) == 0 )) || echo -e "--\nTagging image with tags: $(DOCKER_TAGS)"
	@[[ -z "$(DOCKER_TAGS)" ]] || ./utils/docker-tagger.sh $(BUILD_TARGET):latest $(DOCKER_TAGS)

login-ecr:
	@aws $(AWS_CLI_ARGS) ecr get-login --no-include-email | awk '{ print $$6 }' | docker login --username AWS --password-stdin $(AWS_ECR_HOST)

publish-ecr: login-ecr
	@docker tag $(BUILD_TARGET):latest $(AWS_ECR_HOST)/$(BUILD_TARGET)
	@[[ -z "$(DOCKER_TAGS)" ]] || ./utils/docker-tagger.sh $(AWS_ECR_HOST)/$(BUILD_TARGET):latest $(DOCKER_TAGS)
	@docker push $(AWS_ECR_HOST)/$(BUILD_TARGET)

build: build-$(BUILD_TARGET)
test: test-$(BUILD_TARGET)
