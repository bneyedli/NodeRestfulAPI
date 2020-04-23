resource "aws_ecs_cluster" "node-rest-api" {
  name = "node-rest-api"
}

data "template_file" "task-definition" {
  template = "${file("${path.module}/templates/node-rest-api-svc.json.tmpl")}"
  vars = {
    repo_host     = "171813784747.dkr.ecr.us-east-1.amazonaws.com"
    repo_name     = "node-rest-api"
    container_tag = "latest"
  }
}

resource "aws_ecs_task_definition" "node-rest-api-task" {
  family                = "node-rest-api"
  container_definitions = data.template_file.task-definition.rendered

  volume {
    name      = "service-storage"
    host_path = "/srv/container/data"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${var.aws_region}a, ${var.aws_region}b]"
  }
}

resource "aws_ecs_service" "node-rest-api-svc" {
  name            = "node-rest-api"
  cluster         = aws_ecs_cluster.node-rest-api.id
  task_definition = aws_ecs_task_definition.node-rest-api-task.arn
  desired_count   = 1
  launch_type     = "EC2"

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${var.aws_region}a, ${var.aws_region}b]"
  }
}
