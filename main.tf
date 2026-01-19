# Execute setup script after S3 bucket creation
resource "terraform_data" "setup_script" {
  # This ensures the script runs AFTER the bucket is created
  depends_on = [aws_s3_bucket.images_bucket]

  provisioner "local-exec" {
    # Automates the chmod and execution steps
    command = "chmod +x ${path.module}/scripts/setup.sh && ${path.module}/scripts/setup.sh"
  }
}

# CloudWatch Alarm for Lambda Errors
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "RekognitionLambdaErrors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Sum"
  threshold           = "0"
  alarm_description   = "This alarm triggers if the Lambda fails to process an image."
  dimensions = {
    FunctionName = aws_lambda_function.rekognition_lambda.function_name
  }
}
