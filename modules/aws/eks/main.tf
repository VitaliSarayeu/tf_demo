locals {
  ssm_path     = "/${var.project_name}/${var.project_environment}"
  generated_by = "Genarated by Terraform."
  standard_tags = {
    Environment = var.project_environment
    Project     = var.project_name
  }
}