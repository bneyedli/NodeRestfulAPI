$(WORKDIR)/artifacts:
	@mkdir $@

test-service:
	@echo "Test api endpoint"
	@docker run --rm --name $(BUILD_TARGET) $(BUILD_TARGET) &
	@sleep 1 && curl $$(docker inspect $(BUILD_TARGET) | jq -r .[].NetworkSettings.IPAddress):8080 | jq .
	@docker stop $(BUILD_TARGET)

test-compliance: $(WORKDIR)/artifacts
	@echo "Run compliance tests"
	@(( $(DEBUG) == 0 )) || echo -e "--\n -> Check Linux Patch Baseline"
	@docker run -t --rm --name $(BUILD_TARGET) $(BUILD_TARGET) -w /srv/container/data inspec supermarket exec dev-sec/linux-patch-baseline --reporter=json-min & #> $(WORKDIR)/artifacts/inspec-linux-patch-baseline.json
	@docker logs $(BUILD_TARGET)
	@sleep 5 && docker stop $(BUILD_TARGET)
	@(( $(DEBUG) == 0 )) || echo -e "--\n -> Check Linux Security Baseline"
	@docker run -t --rm --name $(BUILD_TARGET) $(BUILD_TARGET) -w /srv/container/data inspec supermarket exec dev-sec/linux-baseline --reporter=json-min & #> $(WORKDIR)/artifacts/inspec-linux-patch-baseline.json
	@sleep 5 && docker stop $(BUILD_TARGET)
test-$(BUILD_TARGET): test-service test-compliance
