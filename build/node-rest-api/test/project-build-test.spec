$(BUILD_TARGET)-compliance:
	@(( $(DEBUG) == 0 )) || echo -e "--\n -> Check Linux Patch Baseline"
	@docker run --rm $(BUILD_TARGET) inspec supermarket exec dev-sec/linux-patch-baseline --reporter=json-min | jq .
	@(( $(DEBUG) == 0 )) || echo -e "--\n -> Check Linux Security Baseline"
	@docker run --rm $(BUILD_TARGET) inspec supermarket exec dev-sec/linux-baseline --reporter=json-min | jq .
$(BUILD_TARGET)-test: $(BUILD_TARGET)-compliance
