# Create a unique suffix for the bucket name
resource "random_id" "bucket_id" {
  byte_length = 4
}

# S3 Bucket to store uploaded images
resource "aws_s3_bucket" "images_bucket" {
  bucket        = "${var.project_name}-images-bucket-${random_id.bucket_id.hex}"
  force_destroy = true
}

# Enable versioning on the S3 bucket
resource "aws_s3_bucket_versioning" "versioning_images_bucket" {
  bucket = aws_s3_bucket.images_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Lifecycle rule to manage object expiration
resource "aws_s3_bucket_lifecycle_configuration" "images_bucket_lifecycle" {
  bucket = aws_s3_bucket.images_bucket.id

  rule {
    id     = "cleanup-old-files"
    status = "Enabled"

    filter {} # This empty filter tells AWS the rule applies to the WHOLE bucket

    # Permanently delete objects after 30 days
    expiration {
      days = 30
    }

    # If enabled versioning, delete non-current versions after 7 days
    noncurrent_version_expiration {
      noncurrent_days = 7
    }
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.images_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access to the bucket
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.images_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}