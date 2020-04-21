resource "aws_ecs_cluster" "node-rest-api" {
  name = "node-rest-api"
}

resource "aws_ecs_task_definition" "node-rest-api-task" {
  family                = "node-rest-api"
  container_definitions = file("tf-infra/ecs-tasks/node-rest-api-svc.json")

  volume {
    name      = "service-storage"
    host_path = "/srv/container/data"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-east-1a, us-east-1b]"
  }
}

resource "aws_ecs_service" "node-rest-api-svc" {
  name            = "node-rest-api"
  cluster         = aws_ecs_cluster.node-rest-api.id
  task_definition = aws_ecs_task_definition.node-rest-api-task.arn
  desired_count   = 1

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-east-1a, us-east-1b]"
  }
}
