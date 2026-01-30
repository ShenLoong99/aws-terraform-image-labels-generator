output "s3_bucket_name" {
  description = "S3 bucket name for image uploads"
  value       = aws_s3_bucket.images_bucket.bucket
}

output "bucket_obj" {
  description = "The S3 bucket object"
  value       = aws_s3_bucket.images_bucket
}

output "bucket" {
  description = "The S3 bucket"
  value       = aws_s3_bucket.images_bucket.bucket
}

output "rekognition_s3_policy_arn" {
  description = "ARN of rekognition s3 policy"
  value       = aws_iam_policy.rekognition_s3_policy.arn
}
