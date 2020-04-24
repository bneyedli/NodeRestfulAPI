ECS_CONTAINER_HOST_ID=$(shell tf-infra/utils/ecs-get-container-host-ip.sh node-rest-api | jq -r .ecs_container_instance_id)

cycle-container-host:
	@echo "Terminating instance: $(ECS_CONTAINER_HOST_ID)"
	@aws ec2 terminate-instances --instance-ids $(ECS_CONTAINER_HOST_ID)
