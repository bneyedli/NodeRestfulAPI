SHELL=/usr/bin/env bash

ifndef PROVISION_TARGET
 $(error PROVISION_TARGET not defined, please export or pass inline)
endif

ifndef DEBUG
export DEBUG=0
endif

GIT_TAG_LAST=$(shell git tag -l | sort -V | tail -n1)

include $(PROVISION_TARGET)/project-build.spec
#include $(PROVISION_TARGET)/test/project-build-test.spec

init-tf-infra:
	@(( $(DEBUG) == 0 )) || echo -e "--\nInit TF for: $(PROVISION_TARGET)\n\twith args: $(TERRAFORM_PROVISION_ARGS)"
	@test -f .terraform/.tf-init || terraform init $(PROVISION_TARGET)
	@touch .terraform/.tf-init

plan-tf-infra: init-tf-infra
	@(( $(DEBUG) == 0 )) || echo -e "--\nRun TF Plan for: $(PROVISION_TARGET)\n\twith args: $(TERRAFORM_PROVISION_ARGS)"
	@terraform plan $(PROVISION_TARGET)

provision-tf-infra:
	@(( $(DEBUG) == 0 )) || echo -e "--\nApply TF Plan for: $(PROVISION_TARGET)\n\twith args: $(TERRAFORM_PROVISION_ARGS)"
	@terraform apply $(PROVISION_TARGET)

destroy-tf-infra:
	@(( $(DEBUG) == 0 )) || echo -e "--\nDestroy TF Plan for: $(PROVISION_TARGET)\n\twith args: $(TERRAFORM_PROVISION_ARGS)"
	@terraform destroy $(PROVISION_TARGET)

format-tf-infra:
	@terraform fmt $(PROVISION_TARGET)

destroy: destroy-$(PROVISION_TARGET)
plan: plan-$(PROVISION_TARGET)
provision: provision-$(PROVISION_TARGET)
test: test-$(PROVISION_TARGET)
format: format-tf-infra
