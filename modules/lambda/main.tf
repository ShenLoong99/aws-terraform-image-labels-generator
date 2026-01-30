# Zip the Lambda function code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/detect_labels.py" # includes detect_labels.py + python/
  output_path = "${path.module}/lambda/function.zip"
}

# Lambda function for Rekognition
resource "aws_lambda_function" "rekognition_lambda" {
  function_name    = "${var.project_name}-rekognition-lambda"
  role             = aws_iam_role.lambda_role.arn
  runtime          = "python3.11"
  timeout          = 10  # Lambda Timeout Explicitly Set
  memory_size      = 256 # Lambda Memory Explicitly Set
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  handler          = "detect_labels.lambda_handler"

  # Enable X-Ray Tracing for the Lambda function
  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      S3_BUCKET_NAME = var.bucket
    }
  }
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-rekognition-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-lambda-role"
  }
}

# IAM Role Policy Attachments
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Rekognition policy
resource "aws_iam_policy" "rekognition_policy" {
  name        = "${var.project_name}-rekognition-policy"
  description = "Allow Rekognition label detection"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["rekognition:DetectLabels"]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-rekognition-policy"
  }
}
