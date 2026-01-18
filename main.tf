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

# Local file to store configuration for Lambda
resource "local_file" "python_config" {
  filename = "${path.module}/config.json"
  content = jsonencode({
    secret_id   = aws_secretsmanager_secret.dev_keys.name
    region      = var.aws_region
    bucket_name = aws_s3_bucket.images_bucket.bucket
  })
}

# Execute setup script after S3 bucket creation
resource "terraform_data" "setup_script" {
  # This ensures the script runs AFTER the bucket is created
  depends_on = [aws_s3_bucket.images_bucket]

  provisioner "local-exec" {
    # Automates the chmod and execution steps
    command = "chmod +x ${path.module}/setup.sh && ${path.module}/setup.sh"
  }
}
