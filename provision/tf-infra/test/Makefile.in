#sourced by provision/Makefile
ECS_CLUSTER_STATUS=$(shell aws ecs describe-clusters --clusters node-rest-api --query clusters[].status --output text)
ECS_SERVICE_STATUS=$(shell aws ecs describe-services --services node-rest-api --cluster node-rest-api --query services[].status[] --output text)
ECS_TASK_STATUS=$(shell aws ecs describe-task-definition --task-definition node-rest-api --query taskDefinition.status --output text)
ECS_CONTAINER_INSTANCE_IP=$(shell tf-infra/utils/ecs-get-container-host-ip.sh node-rest-api | jq -r .ecs_container_instance_ip)
DNS_HOST_STATUS=$(shell $(WORKDIR)/utils/dns-wait.sh $(ECS_CLUSTER_FQDN))
SSH_STATUS_REMOTE=$(shell nmap -T5 -p 22 $(ECS_CLUSTER_FQDN) | grep "22/tcp open  ssh")

test-$(PROVISION_TARGET):
	@[[ $(ECS_CLUSTER_STATUS) == "ACTIVE" ]]; echo "Cluster status: $(ECS_CLUSTER_STATUS)"
	@[[ $(ECS_TASK_STATUS) == "ACTIVE" ]]; echo "Task status: $(ECS_TASK_STATUS)"
	@[[ $(ECS_SERVICE_STATUS) == "ACTIVE" ]]; echo "Service status: $(ECS_SERVICE_STATUS)"
	@echo "Verify DNS"
	@[[ $(DNS_HOST_STATUS) == "$(ECS_CONTAINER_INSTANCE_IP)" ]] && echo "DNS OK"
	@echo "Verify SSH"
	@[[ "$(SSH_STATUS_REMOTE)" == "22/tcp open  ssh" ]] && echo "SSH OK"
