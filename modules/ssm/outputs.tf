output "access_key_path" {
  description = "SSM access key for local config.json"
  value       = aws_ssm_parameter.access_key.name
}

output "secret_key_path" {
  description = "SSM secret key for local config.json"
  value       = aws_ssm_parameter.secret_key.name
}
