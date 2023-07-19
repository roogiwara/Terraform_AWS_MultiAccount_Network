terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.8.0"
    }
  }
}

provider "aws" {
  alias   = "general"
  region  = var.region
  profile = var.account_profile["GENERAL"]
}

provider "aws" {
  alias   = "prd"
  region  = var.region
  profile = var.account_profile["PRD"]
}

provider "aws" {
  alias   = "dev"
  region  = var.region
  profile = var.account_profile["DEV"]
}

module "keypair-general" {
  source    = "./modules/keypair"
  key_sufix = "general"
  providers = {
    aws = aws.general
  }
}

module "keypair-prd" {
  source    = "./modules/keypair"
  key_sufix = "prd"
  providers = {
    aws = aws.prd
  }
}

module "keypair-dev" {
  source    = "./modules/keypair"
  key_sufix = "dev"
  providers = {
    aws = aws.dev
  }
}

module "general" {
  source             = "./modules/acc_template"
  vpc_cidr           = var.all_vpcs_cidr["ACC1_VPC_CIDR"]
  subnet1_cidr       = var.all_subnets_cidr["ACC1_SN1"]
  subnet2_cidr       = var.all_subnets_cidr["ACC1_SN2"]
  subnet3_cidr       = var.all_subnets_cidr["ACC1_SN3"]
  availability_zone1 = var.availability_zone["AZ1"]
  availability_zone2 = var.availability_zone["AZ2"]
  availability_zone3 = var.availability_zone["AZ3"]
  acc_description    = "general"
  providers = {
    aws = aws.general
  }
}

module "prd" {
  source             = "./modules/acc_template"
  vpc_cidr           = var.all_vpcs_cidr["ACC2_VPC_CIDR"]
  subnet1_cidr       = var.all_subnets_cidr["ACC2_SN1"]
  subnet2_cidr       = var.all_subnets_cidr["ACC2_SN2"]
  subnet3_cidr       = var.all_subnets_cidr["ACC2_SN3"]
  availability_zone1 = var.availability_zone["AZ1"]
  availability_zone2 = var.availability_zone["AZ2"]
  availability_zone3 = var.availability_zone["AZ3"]
  acc_description    = "prd"
  providers = {
    aws = aws.prd
  }
}

module "dev" {
  source             = "./modules/acc_template"
  vpc_cidr           = var.all_vpcs_cidr["ACC3_VPC_CIDR"]
  subnet1_cidr       = var.all_subnets_cidr["ACC3_SN1"]
  subnet2_cidr       = var.all_subnets_cidr["ACC3_SN2"]
  subnet3_cidr       = var.all_subnets_cidr["ACC3_SN3"]
  availability_zone1 = var.availability_zone["AZ1"]
  availability_zone2 = var.availability_zone["AZ2"]
  availability_zone3 = var.availability_zone["AZ3"]
  acc_description    = "dev"
  providers = {
    aws = aws.dev
  }
}

module "ec2_general" {
  source          = "./modules/ec2_template"
  ami_id          = var.ami_id
  instance_type   = var.instance_type
  key_name        = module.keypair-general.keypair_key_name
  security_group  = module.general.security_group_id
  subnet_id       = module.general.subnet_public1_id
  acc_description = "general"
  providers = {
    aws = aws.general
  }
}

module "ec2_prd" {
  source          = "./modules/ec2_template"
  ami_id          = var.ami_id
  instance_type   = var.instance_type
  key_name        = module.keypair-prd.keypair_key_name
  security_group  = module.prd.security_group_id
  subnet_id       = module.prd.subnet_public1_id
  acc_description = "prd"
  providers = {
    aws = aws.prd
  }
}

module "ec2_dev" {
  source          = "./modules/ec2_template"
  ami_id          = var.ami_id
  instance_type   = var.instance_type
  key_name        = module.keypair-dev.keypair_key_name
  security_group  = module.dev.security_group_id
  subnet_id       = module.dev.subnet_public1_id
  acc_description = "dev"
  providers = {
    aws = aws.dev
  }
}