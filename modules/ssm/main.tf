# Store the IAM Access Keys in SSM Parameter Store
resource "aws_ssm_parameter" "access_key" {
  name  = "/${var.project_name}/dev/access_key"
  type  = "SecureString"
  value = aws_iam_access_key.project_user_key.id
}

# Store the IAM Secret Keys in SSM Parameter Store
resource "aws_ssm_parameter" "secret_key" {
  name  = "/${var.project_name}/dev/secret_key"
  type  = "SecureString"
  value = aws_iam_access_key.project_user_key.secret
}

# Create IAM Access Key for the Developer User
resource "aws_iam_access_key" "project_user_key" {
  user = var.user_name
}

# Update the IAM Policy to allow SSM access
resource "aws_iam_policy" "ssm_policy" {
  name        = "${var.project_name}-ssm-policy"
  description = "Allows reading developer keys from SSM Parameter Store"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Effect = "Allow"
        Resource = [
          aws_ssm_parameter.access_key.arn,
          aws_ssm_parameter.secret_key.arn
        ]
      }
    ]
  })
}
