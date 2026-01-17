# IAM Role Policy Attachments
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# IAM Role Policy Attachments
resource "aws_iam_role_policy_attachment" "lambda_attach_s3" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.rekognition_s3_policy.arn
}

# IAM Role Policy Attachments
resource "aws_iam_role_policy_attachment" "lambda_attach_rekognition" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.rekognition_policy.arn
}

# Permission for S3 to invoke Lambda
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rekognition_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.images_bucket.arn
}
