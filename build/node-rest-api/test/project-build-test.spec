test-compliance-$(BUILD_TARGET):
	@(( $(DEBUG) == 0 )) || echo -e "--\n -> Check Linux Patch Baseline"
	@docker run --rm $(BUILD_TARGET) inspec supermarket exec dev-sec/linux-patch-baseline --reporter=json-min | jq .
	@(( $(DEBUG) == 0 )) || echo -e "--\n -> Check Linux Security Baseline"
	@docker run --rm $(BUILD_TARGET) inspec supermarket exec dev-sec/linux-baseline --reporter=json-min | jq .
test-$(BUILD_TARGET): test-compliance-$(BUILD_TARGET)
