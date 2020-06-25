provision:
	@echo "Provisioning stack: tf-node-rest-api-base"
	@cd provision; make plan provision test PROVISION_TARGET=tf-node-rest-api-base

build:
	@echo "Build base ubuntu docker image: docker-base-ubuntu"
	@cd build; make build test BUILD_TARGET=docker-base-ubuntu
	@echo "Build and package modsecurity module and nginx connector: docker-deb-nginx-modsecurity"
	@cd build; make build test BUILD_TARGET=docker-deb-nginx-modsecurity
	@echo "Build base web docker image: docker-base-nginx"
	@cd build; make build test BUILD_TARGET=docker-base-nginx
	@echo "Build app docker image: docker-app-node-rest-api"
	@cd build; make build test BUILD_TARGET=docker-app-node-rest-api

publish:
	@echo "Publish app docker image: docker-node-rest-api"
	@cd build; make test publish BUILD_TARGET=docker-node-rest-api

deploy:
	@echo "Force new deployment of: ecs-node-rest-api"
	@cd deploy; make update-force test DEPLOY_TARGET=ecs-node-rest-api

destroy:
	@echo "Destroy stack: tf-node-rest-api-base"
	@cd provision; make destroy PROVISION_TARGET=tf-node-rest-api-base

purge: destroy
	@echo "Cleanup local docker images"
	@cd build; ./utils/docker-batch-destroy.sh
	@docker images -f "dangling=true" -q | xargs -I {} docker rmi {}

stack: provision build deploy
	@echo "Stack built"

.PHONY: stack provision build deploy
