API_PASS=$(shell aws secretsmanager get-secret-value --secret-id /tf-infra/app/api_pass --query SecretString --output text)

$(WORKDIR)/artifacts:
	@mkdir $@

test-service:
	@echo "Test api endpoint"
	@docker run --rm --name $(BUILD_TARGET) $(BUILD_TARGET) &
	@sleep 2 && curl -s -f --show-error -u junglescout:$(API_PASS) $$(docker inspect $(BUILD_TARGET) | jq -r .[].NetworkSettings.IPAddress):8080 && echo
	@docker stop $(BUILD_TARGET)

test-compliance: $(WORKDIR)/artifacts
	@echo "Run compliance tests"
	@echo -e "--\n -> Check Linux Patch Baseline"
	@docker run -it --rm --name $(BUILD_TARGET) $(BUILD_TARGET) test-compliance.sh dev-sec/linux-patch-baseline > $(WORKDIR)/artifacts/dev-sec-linux-patch-baseline.json || true
	@jq . $(WORKDIR)/artifacts/dev-sec-linux-patch-baseline.json
	@echo -e "--\n -> Check Linux Security Baseline"
	@docker run -it --rm --name $(BUILD_TARGET) $(BUILD_TARGET) test-compliance.sh dev-sec/linux-baseline > $(WORKDIR)/artifacts/dev-sec-linux-baseline.json || true
	@jq . $(WORKDIR)/artifacts/dev-sec-linux-baseline.json

test-$(BUILD_TARGET): test-service test-compliance
