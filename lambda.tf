# Zip the Lambda function code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "lambda/detect_labels.py" # includes detect_labels.py + python/
  output_path = "lambda/function.zip"
}

# Lambda function for Rekognition
resource "aws_lambda_function" "rekognition_lambda" {
  function_name                  = "${var.project_name}-rekognition-lambda"
  role                           = aws_iam_role.lambda_role.arn
  runtime                        = "python3.11"
  timeout                        = 10  # Lambda Timeout Explicitly Set
  memory_size                    = 256 # Lambda Memory Explicitly Set
  reserved_concurrent_executions = 5   # Limit concurrency to control costs
  filename                       = data.archive_file.lambda_zip.output_path
  source_code_hash               = data.archive_file.lambda_zip.output_base64sha256
  handler                        = "detect_labels.lambda_handler"

  # Link the DLQ
  dead_letter_config {
    target_arn = aws_sqs_queue.lambda_dlq.arn
  }

  environment {
    variables = {
      S3_BUCKET_NAME = aws_s3_bucket.images_bucket.bucket
    }
  }

  tracing_config {
    mode = "Active" # Keep for observability
  }

  # This ensures the IAM policy exists BEFORE the Lambda tries to use it.
  depends_on = [
    aws_iam_role_policy.lambda_sqs_policy
  ]
}

# CloudWatch Log Group for Lambda
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.rekognition_lambda.function_name}"
  retention_in_days = 7 # optional, number of days to keep logs
  tags = {
    Name = "${var.project_name}-lambda-log-group"
  }
}

# The Trigger: Notify Lambda when a file is created
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.images_bucket.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.rekognition_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
