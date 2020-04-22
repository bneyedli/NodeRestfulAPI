resource "aws_launch_template" "node-rest-api" {
  name_prefix            = "node-rest-api"
  image_id               = data.aws_ami.ecs.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ingress-http.id]
}

resource "aws_autoscaling_group" "node-rest-api" {
  name                  = "node-rest-api"
  availability_zones    = ["${var.aws_region}a", "${var.aws_region}b"]
  protect_from_scale_in = false
  desired_capacity      = 1
  max_size              = 1
  min_size              = 1

  launch_template {
    id      = aws_launch_template.node-rest-api.id
    version = "$Latest"
  }
}
