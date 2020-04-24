#!/usr/bin/env bash
set -e -u -o pipefail

ECS_CLUSTER=${1}
count=0
count_max=300

while true
do
  cluster_status=$(aws ecs describe-clusters --cluster node-rest-api --query clusters[].status --output text)
  cluster_instance=$(aws ecs list-container-instances --cluster ${ECS_CLUSTER} --query containerInstanceArns --output text|cut -d/ -f2)
  if (( count >= count_max ))
  then
    >&2 echo "Cluster unstable, status: ${cluster_status}" 
    exit 1
  fi

  if [[ ${cluster_status} == "ACTIVE" && -n ${cluster_instance} ]]
  then
    >&2 echo "Cluster alive"
    break
  else
    >&2 echo -n "."	  
    sleep 1
    (( ++ count ))
  fi
done

ECS_CONTAINER_INSTANCE_ID=$(aws ecs describe-container-instances --container-instances ${cluster_instance} --cluster node-rest-api --query containerInstances[].ec2InstanceId --output text)
ECS_CONTAINER_INSTANCE_IP=$(aws ec2 describe-instances --instance-id --query Reservations[].Instances[].PublicIpAddress --output text)

printf '{ "ecs_container_instance": "%s", "ecs_container_instance_id": "%s", "ecs_container_instance_ip": "%s" }' "${cluster_instance}" "${ECS_CONTAINER_INSTANCE_ID}" "${ECS_CONTAINER_INSTANCE_IP}"
