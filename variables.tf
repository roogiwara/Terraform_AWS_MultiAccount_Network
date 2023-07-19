variable "region" {
  default = "sa-east-1"
}

variable "ami_id" {
  default = "ami-0af6e9042ea5a4e3e"
}

variable "instance_type" {
  default = "t2.small"
}

variable "account_profile" {
  type = map(any)
  default = {
    "GENERAL" = "rogiwara-general"
    "PRD"     = "rogiwara-prd"
    "DEV"     = "rogiwara-dev"
  }
}

variable "availability_zone" {
  type = map(any)
  default = {
    "AZ1" = "sa-east-1a"
    "AZ2" = "sa-east-1b"
    "AZ3" = "sa-east-1c"
  }
}

variable "all_vpcs_cidr" {
  type = map(any)
  default = {
    "ACC1_VPC_CIDR" = "10.200.0.0/16"
    "ACC2_VPC_CIDR" = "10.201.0.0/16"
    "ACC3_VPC_CIDR" = "10.202.0.0/16"
  }
}

variable "all_subnets_cidr" {
  type = map(any)
  default = {
    "ACC1_SN1" = "10.200.10.0/24"
    "ACC1_SN2" = "10.200.11.0/24"
    "ACC1_SN3" = "10.200.12.0/24"
    "ACC2_SN1" = "10.201.10.0/24"
    "ACC2_SN2" = "10.201.11.0/24"
    "ACC2_SN3" = "10.201.12.0/24"
    "ACC3_SN1" = "10.202.10.0/24"
    "ACC3_SN2" = "10.202.11.0/24"
    "ACC3_SN3" = "10.202.12.0/24"
  }
}