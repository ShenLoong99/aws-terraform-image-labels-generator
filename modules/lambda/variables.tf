variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "default_tags" {
  description = "Extra tags to pass to the provider"
  type        = map(string)
}

variable "lambda_role_arn" {
  description = "ARN of IAM role for Lambda"
  type        = string
}

variable "bucket" {
  description = "The S3 bucket"
  type        = string
}
