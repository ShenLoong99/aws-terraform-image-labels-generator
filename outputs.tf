output "s3_bucket_name" {
  description = "S3 bucket name for image uploads"
  value       = module.storage.s3_bucket_name
}

output "lambda_execution_role_arn" {
  description = "IAM role ARN assumed by Lambda for S3 + Rekognition access"
  value       = module.iam.lambda_execution_role_arn
}

output "lambda_function_name" {
  description = "Rekognition Lambda function name"
  value       = module.lambda.lambda_function_name
}

output "lambda_role_name" {
  description = "IAM role name for Lambda"
  value       = module.iam.lambda_role_name
}

output "aws_region" {
  description = "The AWS region where resources are deployed"
  value       = var.aws_region
}

output "access_key_path" {
  description = "SSM access key for local config.json"
  value       = module.ssm.access_key_path
}

output "secret_key_path" {
  description = "SSM secret key for local config.json"
  value       = module.ssm.secret_key_path
}
