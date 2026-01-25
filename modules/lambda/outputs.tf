output "lambda_function_name" {
  description = "Rekognition Lambda function name"
  value       = aws_lambda_function.rekognition_lambda.function_name
}
