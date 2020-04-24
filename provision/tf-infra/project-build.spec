ECS_CLUSTER_HOST=node-rest-api
ECS_CLUSTER_DOMAIN=dev.labs.bledsol.net
ECS_CLUSTER_FQDN=$(ECS_CLUSTER_HOST).$(ECS_CLUSTER_DOMAIN)
ECS_CONTAINER_HOST_ID=$(shell tf-infra/utils/ecs-get-container-host-ip.sh node-rest-api | jq -r .ecs_container_instance_id)
TERRAFORM_ARGS=-var 'project_version=$(GIT_TAG_LAST)' \
	-var 'project_name=$(PROVISION_TARGET)' \
	-var 'management_ip=$(MANAGEMENT_IP)' \
	-var 'ecs_cluster_host=$(ECS_CLUSTER_FQDN)' \
	-var 'ecs_cluster_domain=$(ECS_CLUSTER_DOMAIN)'

cycle-container-host:
	@echo "Terminating instance: $(ECS_CONTAINER_HOST_ID)"
	@aws ec2 terminate-instances --instance-ids $(ECS_CONTAINER_HOST_ID)
