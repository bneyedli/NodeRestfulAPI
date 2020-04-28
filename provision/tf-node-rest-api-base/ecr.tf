#Create ECR repository
resource "aws_ecr_repository" "node-rest-api" {
  name                 = "node-rest-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
