SHELL=/usr/bin/env bash
WORKDIR=$(PWD)

ifndef PROVISION_TARGET
 $(error PROVISION_TARGET not defined, please export or pass inline)
endif

ifndef DEBUG
export DEBUG=0
endif

MANAGEMENT_IP=$(shell curl -s ifconfig.me)

GIT_TAG_LAST=$(shell git tag -l | sort -V | tail -n1)

include $(PROVISION_TARGET)/project-build.spec
include $(PROVISION_TARGET)/test/project-build-test.spec


artifacts:
	@mkdir -p $@

init-tf-infra:
	@(( $(DEBUG) == 0 )) || echo -e "--\nInit TF for: $(PROVISION_TARGET)\n\twith args: $(TERRAFORM_PROVISION_ARGS)"
	@test -f .terraform/.tf-init || terraform init $(PROVISION_TARGET)
	@touch .terraform/.tf-init

plan-tf-infra: init-tf-infra artifacts
	@(( $(DEBUG) == 0 )) || echo -e "--\nRun TF Plan for: $(PROVISION_TARGET)\n\twith args: $(TERRAFORM_PROVISION_ARGS)"
	@terraform plan $(TERRAFORM_ARGS) -out=artifacts/tf-plan.zip $(PROVISION_TARGET)

provision-tf-infra:
	@(( $(DEBUG) == 0 )) || echo -e "--\nApply TF Plan for: $(PROVISION_TARGET)\n\twith args: $(TERRAFORM_PROVISION_ARGS)"
	@terraform apply artifacts/tf-plan.zip

destroy-tf-infra:
	@(( $(DEBUG) == 0 )) || echo -e "--\nDestroy TF Plan for: $(PROVISION_TARGET)\n\twith args: $(TERRAFORM_PROVISION_ARGS)"
	@terraform destroy $(TERRAFORM_ARGS) $(PROVISION_TARGET)

format-tf-infra:
	@terraform fmt $(PROVISION_TARGET)

cycle-stack: destroy plan provision test

destroy: destroy-$(PROVISION_TARGET)
plan: plan-$(PROVISION_TARGET)
provision: provision-$(PROVISION_TARGET)
test: test-$(PROVISION_TARGET)
format: format-tf-infra
stack: format plan provision test
