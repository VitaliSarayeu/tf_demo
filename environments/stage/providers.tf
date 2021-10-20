terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.44.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "225099664586-tf-state"
    key    = "stage/terraform.tfstate"
    region = "eu-central-1"
  }
}
