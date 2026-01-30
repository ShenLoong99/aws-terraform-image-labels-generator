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

variable "rekognition_s3_policy_arn" {
  description = "ARN of rekognition s3 policy"
  type        = string
}

variable "rekognition_policy_arn" {
  description = "ARN of rekognition policy"
  type        = string
}
