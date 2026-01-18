terraform {
  required_version = ">= 1.5.0"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "my-terraform-aws-projects-2025"

    workspaces {
      name = "AWS-Image-Labels-Generator"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = "Production"
      ManagedBy   = "Terraform"
      Owner       = "ShenLoong"
    }
  }
}
