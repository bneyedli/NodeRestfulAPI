#Sourced by parent Makefile ../
#Latest lts https://nodejs.org/en/
#NODE_PLATFORM=alpine
#Latest stable https://downloads.chef.io/inspec/stable
DOCKER_DISTRIBUTION=ubuntu
DOCKER_RELEASE=eoan
NODE_VERSION=12
INSPEC_VERSION=4.18.104
GEM_SOURCE_URL=https://rubygems.org
API_PASS=$(shell aws secretsmanager get-secret-value --secret-id /tf-infra/app/api_pass --query SecretString --output text)
DOCKER_BUILD_ARGS=--build-arg DOCKER_DISTRIBUTION=$(DOCKER_DISTRIBUTION) \
		--build-arg DOCKER_RELEASE=$(DOCKER_RELEASE) \
		--build-arg NODE_VERSION=$(NODE_VERSION) \
		--build-arg GEM_SOURCE_URL=$(GEM_SOURCE_URL) \
		--build-arg INSPEC_VERSION=$(INSPEC_VERSION) \
		--build-arg API_PASS=$(API_PASS)
DOCKER_TAGS=$(GIT_TAG_LAST) $(DOCKER_DISTRIBUTION)-$(DOCKER_RELEASE) inspec-$(INSPEC_VERSION) node-$(NODE_VERSION)
GIT_COMMIT_NODE=e00ce896dcf8f985400e3c92b4bac843c9c99934
GIT_DEPENDENCIES=node-restful-api-tutorial

$(BUILD_TARGET)/git-deps:
	@(( $(DEBUG) == 0 )) || echo -e "--\nEnsure $@ dir exists"
	@mkdir -p $@

$(BUILD_TARGET)/git-deps/node-restful-api-tutorial: $(BUILD_TARGET)/git-deps
	@(( $(DEBUG) == 0 )) || echo -e "--\nClone repo: https://github.com/academind/node-restful-api-tutorial.git"
	@git clone https://github.com/academind/node-restful-api-tutorial.git $(BUILD_TARGET)/git-deps/node-restful-api-tutorial

$(BUILD_TARGET)/keys:
	@mkdir -p $@

$(BUILD_TARGET)/keys/nodesource.gpg.key: $(BUILD_TARGET)/keys
	@curl -s -f https://deb.nodesource.com/gpgkey/nodesource.gpg.key -O $@

git-deps: $(BUILD_TARGET)/git-deps/node-restful-api-tutorial
	@(( $(DEBUG) == 0 )) || echo -e "--\nCheckout commit hash: $(GIT_COMMIT_NODE)"
	@cd $(BUILD_TARGET)/git-deps/node-restful-api-tutorial; git checkout $(GIT_COMMIT_NODE)

deps: git-deps $(BUILD_TARGET)/keys/nodesource.gpg.key

build-$(BUILD_TARGET): deps build-docker

.PHONY: git-deps deps
