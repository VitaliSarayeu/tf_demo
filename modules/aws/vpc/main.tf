locals {
  ssm_path     = "/${var.project_name}/${var.project_environment}"
  generated_by = "Genarated by Terraform."
  standard_tags = {
    Environment = var.project_environment
    Project     = var.project_name
  }
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = merge(
    {
      Name = "${var.project_name}-VPC"
    },
    local.standard_tags
  )
}

data "aws_availability_zones" "main_azs" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

resource "aws_ssm_parameter" "vpc_id" {
  name        = "${local.ssm_path}/aws/vpc/vpc_id"
  type        = "String"
  value       = aws_vpc.main.id
  description = "${local.generated_by} VPC ID of the ${var.project_name} for ${var.project_environment} environment"
  tags        = local.standard_tags
}
