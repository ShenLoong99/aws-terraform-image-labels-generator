# Create the IAM Group for the project
resource "aws_iam_group" "developer_group" {
  name = "${var.project_name}-developer-group"
}

# Add the IAM User to the Group
resource "aws_iam_group_membership" "developer_team" {
  name = "${var.project_name}-group-membership"

  users = [
    aws_iam_user.project_user.name
  ]

  group = aws_iam_group.developer_group.name
}

# IAM User for Developer
resource "aws_iam_user" "project_user" {
  name = "${var.project_name}-developer-user"
  tags = {
    Name = "${var.project_name}-user"
  }
}

# Attach the Policies to the GROUP (instead of the user)
resource "aws_iam_group_policy_attachment" "group_attach" {
  for_each = toset([
    aws_iam_policy.rekognition_s3_policy.arn,
    aws_iam_policy.rekognition_policy.arn
  ])
  group      = aws_iam_group.developer_group.name
  policy_arn = each.value
}

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

# This generates the keys you will put in your local terminal
resource "aws_iam_access_key" "project_user_key" {
  user = aws_iam_user.project_user.name
}

# Store the Keys in AWS Secrets Manager instead of Outputs
resource "aws_secretsmanager_secret" "dev_keys" {
  name                    = "${var.project_name}-dev-credentials-new" # Use unique name
  description             = "IAM Access Keys for local Rekognition script"
  recovery_window_in_days = 0 # Forces immediate deletion if destroyed
}

# Store the secret values
resource "aws_secretsmanager_secret_version" "dev_keys_val" {
  secret_id = aws_secretsmanager_secret.dev_keys.id
  secret_string = jsonencode({
    access_key = aws_iam_access_key.project_user_key.id
    secret_key = aws_iam_access_key.project_user_key.secret
  })
}
