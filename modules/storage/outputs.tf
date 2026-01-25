output "s3_bucket_name" {
  description = "S3 bucket name for image uploads"
  value       = aws_s3_bucket.images_bucket.bucket
}

output "bucket_obj" {
  description = "The S3 bucket object"
  value       = aws_s3_bucket.images_bucket
}

output "bucket_arn" {
  description = "ARN of the image bucket"
  value       = aws_s3_bucket.images_bucket.arn
}

output "bucket" {
  description = "The S3 bucket"
  value       = aws_s3_bucket.images_bucket.bucket
}
