terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.8.0"
    }
  }
}

# Criacao da key pair
resource "tls_private_key" "rogiwara-terraform-key" {
  algorithm = "RSA"
}

resource "local_sensitive_file" "private-key" {
  content  = tls_private_key.rogiwara-terraform-key.private_key_pem
  filename = "key-${var.key_sufix}.pem"
}

resource "aws_key_pair" "rogiwara-terraform-key-pair" {
  key_name   = "key-${var.key_sufix}"
  public_key = tls_private_key.rogiwara-terraform-key.public_key_openssh
}