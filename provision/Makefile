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

include $(PROVISION_TARGET)/Makefile.in
include $(PROVISION_TARGET)/test/Makefile.in


artifacts:
	@mkdir -p $@

init-$(PROVISION_TARGET):
	@(( $(DEBUG) == 0 )) || echo -e "--\nInit TF for: $(PROVISION_TARGET)\n\twith args: $(TERRAFORM_PROVISION_ARGS)"
	@test -f .terraform/.tf-init || terraform init $(PROVISION_TARGET)
	@touch .terraform/.tf-init

plan-$(PROVISION_TARGET): init-$(PROVISION_TARGET) artifacts
	@(( $(DEBUG) == 0 )) || echo -e "--\nRun TF Plan for: $(PROVISION_TARGET)\n\twith args: $(TERRAFORM_PROVISION_ARGS)"
	@terraform plan $(TERRAFORM_ARGS) -out=artifacts/$(PROVISION_TARGET)-plan.zip $(PROVISION_TARGET)

provision-$(PROVISION_TARGET):
	@(( $(DEBUG) == 0 )) || echo -e "--\nApply TF Plan for: $(PROVISION_TARGET)\n\twith args: $(TERRAFORM_PROVISION_ARGS)"
	@terraform apply artifacts/$(PROVISION_TARGET)-plan.zip

destroy-$(PROVISION_TARGET):
	@(( $(DEBUG) == 0 )) || echo -e "--\nDestroy TF Plan for: $(PROVISION_TARGET)\n\twith args: $(TERRAFORM_PROVISION_ARGS)"
	@terraform destroy $(TERRAFORM_ARGS) $(PROVISION_TARGET)

format-$(PROVISION_TARGET):
	@terraform fmt $(PROVISION_TARGET)

cycle-stack: destroy plan provision test

destroy: destroy-$(PROVISION_TARGET)
plan: plan-$(PROVISION_TARGET)
provision: provision-$(PROVISION_TARGET)
test: test-$(PROVISION_TARGET)
format: format-$(PROVISION_TARGET)
stack: format plan provision test
