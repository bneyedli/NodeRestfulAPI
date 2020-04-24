resource "aws_security_group" "ingress-web" {
  name        = "ingress-web"
  description = "Allow inbound web traffic"

  ingress {
    description = "HTTP Ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS Ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ingress-web"
  }
}

resource "aws_security_group" "ingress-ssh" {
  name        = "ingress-ssh"
  description = "Allow inbound SSH traffic"

  ingress {
    description = "SSH Ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.management_ip}/32"]
  }

  tags = {
    Name = "ingress-ssh"
  }
}

resource "aws_security_group" "egress-default" {
  name        = "egress-default"
  description = "Allow all outbound traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
