variable "vpc_cidr_block" {
  default = "172.31.0.0/16"
}

variable "project_name" {
  type = string
}

variable "project_environment" {
  type = string
}

variable "aws_region" {
  default = "us-east-1"
}

variable "additional_private_subnet_tags" {
  type    = map
  default = {}
}

variable "additional_public_subnet_tags" {
  type    = map
  default = {}
}
