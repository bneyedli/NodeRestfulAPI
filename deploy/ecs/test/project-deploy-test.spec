#sourced by provision/Makefile
ECS_CLUSTER_HOST=node-rest-api
ECS_CLUSTER_DOMAIN=dev.labs.bledsol.net
ECS_CLUSTER_FQDN=$(ECS_CLUSTER_HOST).$(ECS_CLUSTER_DOMAIN)
API_PASS=$(shell aws secretsmanager get-secret-value --secret-id /tf-infra/app/api_pass --query SecretString --output text)
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
	@dig +short $(ECS_CLUSTER_HOST) >/dev/null && echo "DNS OK"
	@echo "Verify endpoint: $(ECS_CLUSTER_FQDN) with user: junglescout"
	@curl -s -f --show-error -u junglescout:$(API_PASS) $(ECS_CLUSTER_FQDN) && echo
