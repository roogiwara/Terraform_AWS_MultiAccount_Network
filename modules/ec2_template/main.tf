terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.8.0"
    }
  }
}

resource "aws_instance" "ec2_public" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  security_groups             = ["${var.security_group}"]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  tags = {
    Name = "Ubuntu-${var.acc_description}"
  }
}