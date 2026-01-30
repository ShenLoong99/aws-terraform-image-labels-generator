output "user_name" {
  description = "Name of the authorized project user"
  value       = aws_iam_user.project_user.name
}
