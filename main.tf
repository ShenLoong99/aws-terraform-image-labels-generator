# Local variables
locals {
  common_tags = {
    Project     = var.project_name
    Environment = "Production"
    ManagedBy   = "Terraform"
    Owner       = "ShenLoong"
  }
}

# Module for S3
module "storage" {
  source       = "./modules/storage"
  project_name = var.project_name
  aws_region   = var.aws_region
  default_tags = local.common_tags
}

# Module for System Manager
module "ssm" {
  source       = "./modules/ssm"
  user_name    = module.iam.user_name
  project_name = var.project_name
  aws_region   = var.aws_region
  default_tags = local.common_tags
}

# Module for IAM (Permissions, roles, policies)
module "iam" {
  source         = "./modules/iam"
  bucket_arn     = module.storage.bucket_arn
  access_key_arn = module.ssm.access_key_arn
  secret_key_arn = module.ssm.secret_key_arn
  project_name   = var.project_name
  aws_region     = var.aws_region
  default_tags   = local.common_tags
}

# Module for Lambda
module "lambda" {
  source          = "./modules/lambda"
  lambda_role_arn = module.iam.lambda_role_arn
  bucket          = module.storage.bucket
  project_name    = var.project_name
  aws_region      = var.aws_region
  default_tags    = local.common_tags
}

# Execute setup script after S3 bucket creation
resource "terraform_data" "setup_script" {
  # This ensures the script runs AFTER the bucket is created
  depends_on = [module.storage.bucket_obj]

  provisioner "local-exec" {
    # Automates the chmod and execution steps
    command = "chmod +x ${path.module}/scripts/setup.sh && ${path.module}/scripts/setup.sh"
  }
}

# Commented to reduce any potential cost
# CloudWatch Alarm for Lambda Errors
# resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
#   alarm_name          = "RekognitionLambdaErrors"
#   comparison_operator = "GreaterThanThreshold"
#   evaluation_periods  = "1"
#   metric_name         = "Errors"
#   namespace           = "AWS/Lambda"
#   period              = "60"
#   statistic           = "Sum"
#   threshold           = "0"
#   alarm_description   = "This alarm triggers if the Lambda fails to process an image."
#   dimensions = {
#     FunctionName = module.lambda.lambda_function_name
#   }
# }
