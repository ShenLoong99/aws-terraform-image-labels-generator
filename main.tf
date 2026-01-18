# IAM Role Policy Attachments
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# CloudWatch Log Group for Lambda
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.rekognition_lambda.function_name}"
  retention_in_days = 7 # optional, number of days to keep logs
  tags = {
    Name = "${var.project_name}-lambda-log-group"
  }
}
