data "aws_iam_policy_document" "ec2-assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

  }
}

data "aws_iam_policy_document" "ecr-read" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:ListTagsForResource",
    "ecr:DescribeImageScanFindings"]

    resources = [aws_ecr_repository.node-rest-api.arn]

  }
  statement {
    actions = [ "ecr:GetAuthorizationToken" ]
    resources = ["*"]
  }

}

resource "aws_iam_policy" "ecr-read" {
  name   = "ecr-read"
  policy = data.aws_iam_policy_document.ecr-read.json
}

resource "aws_iam_role" "ecs" {
  name               = "ecs"
  assume_role_policy = data.aws_iam_policy_document.ec2-assume.json
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.ecs.name
  policy_arn = aws_iam_policy.ecr-read.arn
}
