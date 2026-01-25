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

variable "bucket_arn" {
  description = "ARN of the image bucket"
  type        = string
}

variable "access_key_arn" {
  description = "ARN of SSM access key"
  type        = string
}

variable "secret_key_arn" {
  description = "ARN of SSM secret key"
  type        = string
}
