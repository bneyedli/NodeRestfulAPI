#SSH Key for container host(s)
resource "tls_private_key" "deploy-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#Register public key with AWS
resource "aws_key_pair" "deploy-key" {
  key_name   = "${var.project_name}-deploy"
  public_key = tls_private_key.deploy-key.public_key_openssh
}

#Create secret resource for deploy key
resource "aws_secretsmanager_secret" "deploy-key" {
  name                    = "/${var.project_name}/deploy/ssh_key"
  recovery_window_in_days = 0
}

#Register secret key with AWS SecretsManager
resource "aws_secretsmanager_secret_version" "deploy-key" {
  secret_id     = aws_secretsmanager_secret.deploy-key.id
  secret_string = tls_private_key.deploy-key.private_key_pem
}

#Generate random password for api
resource "random_password" "api-pass" {
  length           = 42
  special          = true
  override_special = "_%@"
}

#Create secret resource for api password
resource "aws_secretsmanager_secret" "api-pass" {
  name                    = "/${var.project_name}/app/api_pass"
  recovery_window_in_days = 0
}

#Register API password with secrets manager
resource "aws_secretsmanager_secret_version" "api-pass" {
  secret_id     = aws_secretsmanager_secret.api-pass.id
  secret_string = random_password.api-pass.result
}
