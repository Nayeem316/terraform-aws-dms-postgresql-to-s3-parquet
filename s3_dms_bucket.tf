# s3_dms_bucket.tf
# S3 bucket where DMS will write Parquet files


resource "aws_s3_bucket" "dms_bucket" {
  # Bucket names must be globally unique
  bucket = local.dms_bucket_name

  tags = merge(local.common_tags, { Name = "dms-hr-parquet-bucket" })
}

# Optional but recommended: enable versioning
resource "aws_s3_bucket_versioning" "dms_bucket_versioning" {
  bucket = aws_s3_bucket.dms_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Optional but recommended: block public access
resource "aws_s3_bucket_public_access_block" "dms_bucket_block_public" {
  bucket = aws_s3_bucket.dms_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
