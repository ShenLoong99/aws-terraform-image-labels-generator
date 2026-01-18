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
  user = aws_iam_user.project_user.name
}
