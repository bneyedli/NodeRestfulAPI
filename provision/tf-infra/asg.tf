#Userdata template for container hosts
data "template_file" "user-data" {
  template = "${file("${path.module}/templates/userdata.sh.tmpl")}"
  vars = {
    cluster_name = aws_ecs_cluster.node-rest-api.name
  }
}

#Launch template for container hosts
resource "aws_launch_template" "node-rest-api" {
  name_prefix            = "node-rest-api"
  image_id               = data.aws_ami.ecs.id
  instance_type          = "t3a.small"
  vpc_security_group_ids = [aws_security_group.ingress-http.id]
  user_data              = base64encode(data.template_file.user-data.rendered)
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2.id
  }
}

#ASG for container hosts
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
