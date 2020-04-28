provision:
	@echo "Provisioning stack: tf-node-rest-api-base"
	@cd provision; make plan provision test PROVISION_TARGET=tf-node-rest-api-base

build:
	@echo "Build base ubuntu docker image: docker-ubuntu-base"
	@cd build; make build test BUILD_TARGET=docker-ubuntu-base
	@echo "Build base web docker image: docker-ubuntu-web"
	@cd build; make build test BUILD_TARGET=docker-ubuntu-web
	@echo "Build base app docker image: docker-node-rest-api"
	@cd build; make build test publish BUILD_TARGET=docker-node-rest-api

deploy:
	@echo "Force new deployment of: ecs-node-rest-api"
	@cd deploy; make update-force test DEPLOY_TARGET=ecs-node-rest-api

destroy:
	@echo "Destroy stack: tf-node-rest-api-base"
	@cd provision; make destroy PROVISION_TARGET=tf-node-rest-api-base

stack: provision build deploy

.PHONY: stack provision build deploy
