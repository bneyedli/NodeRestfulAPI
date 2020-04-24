#Policy document to allow assuming roles for ec2
data "aws_iam_policy_document" "ec2-assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

  }
}

#Policy document to allow putting custom cloudwatch metrics
data "aws_iam_policy_document" "cloudwatch-put" {
  statement {
    actions   = ["cloudwatch:PutMetricData"]
    resources = ["*"]
  }
}

#Register policy from document
resource "aws_iam_policy" "policy" {
  name        = "cloudwatch_put"
  description = "Cloudwatch put metrics"
  policy      = data.aws_iam_policy_document.cloudwatch-put.json
}

#IAM Role for EC2 Cluster instances
resource "aws_iam_role" "ec2" {
  name               = "ec2"
  assume_role_policy = data.aws_iam_policy_document.ec2-assume.json
}

#Attach Managed AWS policy for EC2 Containers
resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

#Attach custom policy for cloudwatch
resource "aws_iam_role_policy_attachment" "cloudwatch-put-attachment" {
  role       = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "ec2" {
  name = "ec2"
  path = "/"
  role = aws_iam_role.ec2.id
}
