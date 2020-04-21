SHELL=/usr/bin/env bash

ifndef BUILD_TARGET
 $(error BUILD_TARGET not defined, please export or pass inline)
endif

ifndef DEBUG
export DEBUG=0
endif

GIT_TAG_LAST=$(shell git tag -l | sort -V | tail -n1)

include $(BUILD_TARGET)/project-build.spec
#include $(BUILD_TARGET)/test/project-build-test.spec

init-tf-infra:
	@(( $(DEBUG) == 0 )) || echo -e "--\nInit TF for: $(BUILD_TARGET)\n\twith args: $(TERRAFORM_PROVISION_ARGS)"
	@test -f $(BUILD_TARGET)/.tf-init || terraform init $(BUILD_TARGET)
	@touch $(BUILD_TARGET)/.tf-init

plan-tf-infra: init-tf-infra
	@(( $(DEBUG) == 0 )) || echo -e "--\nRun TF Plan for: $(BUILD_TARGET)\n\twith args: $(TERRAFORM_PROVISION_ARGS)"
	@terraform plan $(BUILD_TARGET)

provision-tf-infra:
	@(( $(DEBUG) == 0 )) || echo -e "--\nApply TF Plan for: $(BUILD_TARGET)\n\twith args: $(TERRAFORM_PROVISION_ARGS)"
	@terraform apply $(BUILD_TARGET)

destroy-tf-infra:
	@(( $(DEBUG) == 0 )) || echo -e "--\nDestroy TF Plan for: $(BUILD_TARGET)\n\twith args: $(TERRAFORM_PROVISION_ARGS)"
	@terraform destroy $(BUILD_TARGET)

destroy: destroy-$(BUILD_TARGET)
plan: plan-$(BUILD_TARGET)
provision: provision-$(BUILD_TARGET)
test: test-$(BUILD_TARGET)
