terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.8.0"
    }
  }
}

# Cria o VPC
resource "aws_vpc" "rogiwara_vpc" {
  cidr_block         = "${var.vpc_cidr}"
  instance_tenancy   = "default"
  enable_dns_support = true
  tags = {
    Name = "rogiwara-vpc-${var.acc_description}"
  }
}

# Cria o DHCP OptionSet
resource "aws_vpc_dhcp_options" "rogiwara_dhcp" {
  domain_name_servers = ["AmazonProvidedDNS", "8.8.8.8"]

  tags = {
    Name = "rogiwara-dhcp-${var.acc_description}"
  }
}

# Associa o DHCP Option ao VPC
resource "aws_vpc_dhcp_options_association" "rogiwara_dns_resolver" {
  vpc_id          = aws_vpc.rogiwara_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.rogiwara_dhcp.id
}

# Cria a subnet publica na AZ 1
resource "aws_subnet" "rogiwara_public1" {
  vpc_id                  = aws_vpc.rogiwara_vpc.id
  cidr_block              = "${var.subnet1_cidr}"
  availability_zone       = "${var.availability_zone1}"
  map_public_ip_on_launch = true
  tags = {
    Name = "rogiwara-${var.acc_description}-public1"
  }
}

# Cria a subnet publica na AZ 2
resource "aws_subnet" "rogiwara_public2" {
  vpc_id                  = aws_vpc.rogiwara_vpc.id
  cidr_block              = "${var.subnet2_cidr}"
  availability_zone       = "${var.availability_zone2}"
  map_public_ip_on_launch = true
  tags = {
    Name = "rogiwara-${var.acc_description}-public2"
  }
}

# Cria a subnet publica na AZ 3
resource "aws_subnet" "rogiwara_public3" {
  vpc_id                  = aws_vpc.rogiwara_vpc.id
  cidr_block              = "${var.subnet3_cidr}"
  availability_zone       = "${var.availability_zone3}"
  map_public_ip_on_launch = true
  tags = {
    Name = "rogiwara-${var.acc_description}-public3"
  }
}

# Cria o Internet Gateway e attacha na VPC
resource "aws_internet_gateway" "rogiwara_igw" {
  vpc_id = aws_vpc.rogiwara_vpc.id
}

# Cria uma Route Table e adiciona a rota default apontando para o IGW
resource "aws_route_table" "rogiwara_rt_public" {
  vpc_id = aws_vpc.rogiwara_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rogiwara_igw.id
  }
  tags = {
    Name = "rogiwara-${var.acc_description}-rt-public"
  }

  depends_on = [aws_internet_gateway.rogiwara_igw]
}

# Associa a Route Table na Subnet 1
resource "aws_route_table_association" "rogiwara-rt-public-association1" {
  subnet_id      = aws_subnet.rogiwara_public1.id
  route_table_id = aws_route_table.rogiwara_rt_public.id
}

# Associa a Route Table na Subnet 2
resource "aws_route_table_association" "rogiwara-rt-public-association2" {
  subnet_id      = aws_subnet.rogiwara_public2.id
  route_table_id = aws_route_table.rogiwara_rt_public.id
}

# Associa a Route Table na Subnet 3
resource "aws_route_table_association" "rogiwara-rt-public-association3" {
  subnet_id      = aws_subnet.rogiwara_public3.id
  route_table_id = aws_route_table.rogiwara_rt_public.id
}

# Cria o Securit Group
resource "aws_security_group" "rogiwara_sg" {
  vpc_id      = aws_vpc.rogiwara_vpc.id
  name        = "RogiwaraSG-${var.acc_description}"
  description = "Default SG for vpc Rogiwara - ${var.acc_description}"
  ingress {
    description = "Allow ICMP"
    from_port   = "-1"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow RDP Access"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Loopback"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}