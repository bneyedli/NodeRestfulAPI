resource "aws_ecs_cluster" "node-rest-api" {
  name = "node-rest-api"
}

resource "aws_ecs_task_definition" "node-rest-api-task" {
  family                = "node-rest-api"
  container_definitions = file("tf-infra/ecs-tasks/node-rest-api-svc.json")
  execution_role_arn    = aws_iam_role.ecs.arn

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

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${var.aws_region}a, ${var.aws_region}b]"
  }
}

resource "aws_ecs_capacity_provider" "node-rest-api" {
  name = "node-rest-api-cap"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.node-rest-api.arn

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 1
    }
  }
}
