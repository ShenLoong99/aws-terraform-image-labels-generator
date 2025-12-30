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
