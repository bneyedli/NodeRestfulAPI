#AMI For EC2 Container hosts
data "aws_ami" "ecs" {
  most_recent = true
  owners      = ["591542846629"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.*"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "hypervisor"
    values = ["xen"]
  }
}

#Collect metadata from ECS cluster
data "external" "ecs-cluster-meta" {
  program = ["${path.module}/utils/ecs-get-container-host-ip.sh","node-rest-api"]
}
