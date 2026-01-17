# S3 policy for Rekognition access
resource "aws_iam_policy" "rekognition_s3_policy" {
  name        = "${var.project_name}-s3-policy"
  description = "Read-only access to the images bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = [aws_s3_bucket.images_bucket.arn]
      },
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = ["${aws_s3_bucket.images_bucket.arn}/*"]
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-s3-policy"
  }
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

# IAM Role for Lambda
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
    Name = "${var.project_name}-lambda-role"
  }
}
