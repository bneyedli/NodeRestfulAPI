SHELL=/usr/bin/env bash
ECS_CLUSTER_NAME=node-rest-api
ECS_TASK_NAME=node-rest-api
ECS_SERVICE_NAME=node-rest-api
ECS_TASK_REVISION=$(shell aws ecs describe-task-definition --task-definition $(ECS_TASK_NAME) --query taskDefinition.revision)
ECS_TASK_RUNNING_REVISION=$(shell aws ecs describe-services --cluster $(ECS_CLUSTER_NAME) --services $(ECS_SERVICE_NAME) --query services[].taskDefinition --output text | cut -d/ -f2 | cut -d: -f2)
	

update-service-check:
	@[[ $(ECS_TASK_REVISION) != $(ECS_TASK_RUNNING_REVISION) ]] || ( echo "Latest task revision and running revision are the same, use -force if you mean it" && exit 1)

update-service: update-service-check
	@aws ecs update-service --service $(ECS_SERVICE_NAME) --task-definition $(ECS_TASK_NAME) --cluster $(ECS_CLUSTER_NAME) --query service.events

update-service-force:
	@aws ecs update-service --service $(ECS_SERVICE_NAME) --task-definition $(ECS_TASK_NAME) --cluster $(ECS_CLUSTER_NAME) --query service.events
