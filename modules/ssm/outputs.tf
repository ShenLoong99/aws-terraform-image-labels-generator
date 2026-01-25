output "access_key_path" {
  description = "SSM access key for local config.json"
  value       = aws_ssm_parameter.access_key.name
}

output "secret_key_path" {
  description = "SSM secret key for local config.json"
  value       = aws_ssm_parameter.secret_key.name
}

output "access_key_arn" {
  description = "ARN of SSM access key"
  value       = aws_ssm_parameter.access_key.arn
}

output "secret_key_arn" {
  description = "ARN of SSM secret key"
  value       = aws_ssm_parameter.secret_key.arn
}
