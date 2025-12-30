# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

// Zip the app/ folder into function.zip
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "lambda/detect_labels.py" # includes detect_labels.py + python/
  output_path = "lambda/function.zip"
}

// S3 Bucket (Image Storage)
resource "aws_s3_bucket" "images_bucket" {
  bucket        = "${var.project_name}-images-bucket-${random_id.bucket_id.hex}"
  force_destroy = true // empty bucket and destroy even if it has object

  tags = {
    Name    = "${var.project_name}-bucket"
    Project = var.project_name
  }
}

resource "aws_s3_bucket_versioning" "versioning_images_bucket" {
  bucket = aws_s3_bucket.images_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket_lifecycle_configuration" "images_bucket_lifecycle" {
  bucket = aws_s3_bucket.images_bucket.id

  rule {
    id     = "cleanup-old-files"
    status = "Enabled"

    filter {} # This empty filter tells AWS the rule applies to the WHOLE bucket

    # Example 1: Permanently delete objects after 30 days
    expiration {
      days = 30
    }

    # Example 2: If you enabled versioning, delete non-current versions after 7 days
    noncurrent_version_expiration {
      noncurrent_days = 7
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.images_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

///////////////////////////////////////////////////////////////////////////////

// Public access blocked (test)
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.images_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

// S3 read-only policy
resource "aws_iam_policy" "rekognition_s3_policy" {
  name        = "${var.project_name}-s3-policy"
  description = "Read-only access to the images bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.images_bucket.arn,
          "${aws_s3_bucket.images_bucket.arn}/*"
        ]
      }
    ]
  })

  tags = {
    Name    = "${var.project_name}-s3-policy"
    Project = var.project_name
  }
}

// Rekognition policy
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
    Name    = "${var.project_name}-rekognition-policy"
    Project = var.project_name
  }
}

// IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-lambda-role"

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
    Name    = "${var.project_name}-lambda-role"
    Project = var.project_name
  }
}

# Attach managed policies
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// Attach S3 & Rekognition policies to the role
resource "aws_iam_role_policy_attachment" "lambda_attach_s3" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.rekognition_s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_attach_rekognition" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.rekognition_policy.arn
}
//////////////////////////////////////////////////////////////////////////////////////

// Use role in Lambda
resource "aws_lambda_function" "rekognition_lambda" {
  function_name = "${var.project_name}-rekognition-lambda"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.11"
  timeout       = 10  # Lambda Timeout Explicitly Set
  memory_size   = 256 # Lambda Memory Explicitly Set

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  handler = "detect_labels.lambda_handler"

  environment {
    variables = {
      S3_BUCKET_NAME = aws_s3_bucket.images_bucket.bucket
    }
  }
}

// Declare CloudWatch log group
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.rekognition_lambda.function_name}"
  retention_in_days = 7 # optional, number of days to keep logs
  tags = {
    Name    = "${var.project_name}-lambda-role"
    Project = var.project_name
  }
}

// The Trigger: Notify Lambda when a file is created
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.images_bucket.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.rekognition_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}

// Permission for S3 to call Lambda
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rekognition_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.images_bucket.arn
}