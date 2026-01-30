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
  for_each = {
    s3_policy          = var.rekognition_s3_policy_arn
    rekognition_policy = var.rekognition_policy_arn
  }

  group      = aws_iam_group.developer_group.name
  policy_arn = each.value
}
