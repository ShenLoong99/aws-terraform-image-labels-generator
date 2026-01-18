output "s3_bucket_name" {
  description = "S3 bucket name for image uploads"
  value       = aws_s3_bucket.images_bucket.bucket
}

output "lambda_execution_role_arn" {
  description = "IAM role ARN assumed by Lambda for S3 + Rekognition access"
  value       = aws_iam_role.lambda_role.arn
}

output "lambda_function_name" {
  description = "Rekognition Lambda function name"
  value       = aws_lambda_function.rekognition_lambda.function_name
}

output "lambda_role_name" {
  description = "IAM role name for Lambda"
  value       = aws_iam_role.lambda_role.name
}

output "aws_region" {
  description = "The AWS region where resources are deployed"
  value       = var.aws_region
}

output "developer_access_key_id" {
  description = "Access key ID for the developer IAM user"
  value       = aws_iam_access_key.project_user_key.id
}
