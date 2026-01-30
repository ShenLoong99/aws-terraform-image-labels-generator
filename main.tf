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
  user_name    = module.auth.user_name
  project_name = var.project_name
  aws_region   = var.aws_region
  default_tags = local.common_tags
}

# Module for IAM (Permissions, roles, policies)
module "auth" {
  source                    = "./modules/auth"
  project_name              = var.project_name
  aws_region                = var.aws_region
  default_tags              = local.common_tags
  rekognition_policy_arn    = module.lambda.rekognition_policy_arn
  rekognition_s3_policy_arn = module.storage.rekognition_s3_policy_arn
}

# Module for Lambda
module "lambda" {
  source       = "./modules/lambda"
  bucket       = module.storage.bucket
  project_name = var.project_name
  aws_region   = var.aws_region
  default_tags = local.common_tags
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
