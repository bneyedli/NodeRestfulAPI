SHELL=/usr/bin/env bash
WORKDIR=$(PWD)
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
GIT_HASH_LAST=$(shell git rev-parse HEAD)
DOCKER_IMAGE=$(subst docker-,,$(BUILD_TARGET))

$(info $(BUILD_TARGET))
$(info $(TARGET))

include $(BUILD_TARGET)/Makefile.in
include $(BUILD_TARGET)/test/Makefile.in

DOCKER_TAGS=$(GIT_TAG_LAST) git-$(GIT_HASH_LAST) $(DOCKER_TAGS_PROJECT)

#export DOCKER_BUILDKIT=1

build-docker:
	@echo -e "--\nBuilding docker image: $(DOCKER_IMAGE)\n\twith args: $(DOCKER_BUILD_ARGS)"
	@docker build -t $(DOCKER_IMAGE):latest $(DOCKER_BUILD_ARGS) $(BUILD_TARGET)
	@echo -e "--\nTagging image with tags: $(DOCKER_TAGS)"
	@[[ -z "$(DOCKER_TAGS)" ]] || ./utils/docker-tagger.sh $(DOCKER_IMAGE):latest $(DOCKER_TAGS)

build-docker-clean:
	@echo -e "--\nBuilding docker image: $(DOCKER_IMAGE)\n\twith args: $(DOCKER_BUILD_ARGS)"
	@docker build --no-cache -t $(DOCKER_IMAGE):latest $(DOCKER_BUILD_ARGS) $(BUILD_TARGET)
	@echo -e "--\nTagging image with tags: $(DOCKER_TAGS)"
	@[[ -z "$(DOCKER_TAGS)" ]] || ./utils/docker-tagger.sh $(DOCKER_IMAGE):latest $(DOCKER_TAGS)
	@echo Tagged

purge-docker:
	docker images $(DOCKER_IMAGE) | grep -v ^REPOSITORY | tr -s ' ' | cut -d ' ' -f 2 | grep -v none | xargs -I {} docker rmi $(DOCKER_IMAGE):{} || true
	docker images $(AWS_ECR_HOST)/$(DOCKER_IMAGE) | grep -v ^REPOSITORY | tr -s ' ' | cut -d ' ' -f 1 | grep -v none | xargs -I {} docker rmi $(AWS_ECR_HOST)/$(DOCKER_IMAGE):{} || true

login-ecr:
	@aws $(AWS_CLI_ARGS) ecr get-login --no-include-email | awk '{ print $$6 }' | docker login --username AWS --password-stdin $(AWS_ECR_HOST)

publish-ecr: login-ecr
	@docker tag $(DOCKER_IMAGE):latest $(AWS_ECR_HOST)/$(DOCKER_IMAGE)
	@[[ -z "$(DOCKER_TAGS)" ]] || ./utils/docker-tagger.sh $(AWS_ECR_HOST)/$(DOCKER_IMAGE):latest $(DOCKER_TAGS)
	@docker push $(AWS_ECR_HOST)/$(DOCKER_IMAGE)

publish: publish-ecr
build: build-$(BUILD_TARGET)
test: test-$(BUILD_TARGET)
