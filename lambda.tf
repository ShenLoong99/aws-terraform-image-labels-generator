# Zip the Lambda function code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "lambda/detect_labels.py" # includes detect_labels.py + python/
  output_path = "lambda/function.zip"
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

  environment {
    variables = {
      S3_BUCKET_NAME = aws_s3_bucket.images_bucket.bucket
    }
  }
}
