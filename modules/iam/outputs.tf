output "lambda_execution_role_arn" {
  description = "IAM role ARN assumed by Lambda for S3 + Rekognition access"
  value       = aws_iam_role.lambda_role.arn
}

output "lambda_role_name" {
  description = "IAM role name for Lambda"
  value       = aws_iam_role.lambda_role.name
}

output "lambda_role_arn" {
  description = "ARN of IAM role for Lambda"
  value       = aws_iam_role.lambda_role.arn
}

output "user_name" {
  description = "Name of the authorized project user"
  value       = aws_iam_user.project_user.name
}
